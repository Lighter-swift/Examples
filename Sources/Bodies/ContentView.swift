//
//  ContentView.swift
//  Bodies
//
//  Created by Helge Heß on 10.08.22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    let database : BodiesDB
    
    @State private var bodies : [ SolarBody ] = []

    /// The current search string.
    @State private var searchString = ""
    
    @MainActor // to work on the `@State` properties, we need to be on main
    func loadFromCache() async {
        bodies = try! await database.solarBodies.fetch(orderBy: \.englishName) {
            $0.englishName.contains(searchString, caseInsensitive: true)
        }
        print("Fetched #\(bodies.count) from database.")
    }

    var body: some View {
        List(bodies) { body in
            Label {
                VStack(alignment: .leading) {
                    Text(verbatim: body.englishName)
                        .font(.headline)
                    
                    Text("Type: \(body.bodyType.capitalized)")
                    if let s = body.discoveredBy, !s.isEmpty {
                        Text("Discovered by: \(s)")
                    }
                }
            } icon: {
                switch body.bodyType {
                    case "Moon"   : Image(systemName: "moon")
                    case "Planet" : Image(systemName: "globe")
                    case "Star"   : Image(systemName: "star")
                    default:
                        let c0 = body.bodyType.first?.lowercased()
                        Image(systemName: "\(c0 ?? "?").circle")
                }
            }
        }
        .searchable(text: $searchString)
        .refreshable { // pull-to-refresh
            Task.detached { try await fetchAndUpdateCache() }
        }
        .task(id: searchString) {
            // On startup we first load all the existing bodies from
            // the cache database, which is superfast.
            // It will be empty on the first run.
            await loadFromCache()
        }
        .task {
            // We run this detached, because decoding the network data
            // using Codable isn't very fast and would block the UI.
            Task.detached(priority: .background) {
                // Then we re-fetch the Data from the network and
                // update our cache with the fresh data.
                try await fetchAndUpdateCache()
            }
        }
        #if os(macOS)
        .padding(.top, 1) // don't ask
        #endif
    }
    
    private func fetchAndUpdateCache() async throws {
        let url = URL(string: "https://api.le-systeme-solaire.net/rest/bodies")!
        
        // Fetch raw data from endpoint.
        let ( data, _ ) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON. The actual JSON struct doesn't contain the
        // bodies at the root, so we need a little helper struct:
        struct Result: Decodable {
            let bodies : [ SolarBody ]
        }
        let result = try JSONDecoder().decode(Result.self, from: data)
        
        // Now we need to merge the results we have in the database with the
        // once we got from the web.
        // We don't actually compare the values, but just overwrite existing
        // records if they are still the same.
        
        // Here we only fetch the IDs of the table using a `select`.
        let oldIDs = Set(try await database.select(from: \.solarBodies, \.id))
        
        // Calculate the changes on background thread.
        let idsToDelete     = oldIDs.subtracting(result.bodies.map(\.id))
        let recordsToUpdate = result.bodies.filter {  oldIDs.contains($0.id) }
        let recordsToInsert = result.bodies.filter { !oldIDs.contains($0.id) }
        
        print("Changes: #\(idsToDelete.count) deleted,",
              "updating #\(recordsToUpdate.count),", // likely the same ...
              "#\(recordsToInsert.count) new.")
        
        // Apply changes in a transaction. Either succeeds completely or not.
        try await database.transaction { tx in
            // Using a transaction is also a little more efficient, because the
            // same database thread and handle is reused.
            // Note that a transaction _body_ is NOT asynchronous to avoid
            // accidential deadlocks. The full transaction can be async though.
            try tx.delete(from: \.solarBodies, where: { $0.id.in(idsToDelete) })
            try tx.update(recordsToUpdate)
            try tx.insert(recordsToInsert)
        }
        
        // Our sync worked, we should now have the records in the database.
        await loadFromCache()
    }
}
