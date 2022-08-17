<h2>Lighter Example: Bodies SwiftUI App
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

A very simple SwiftUI example that accesses the 
[The Solar System OpenData](https://api.le-systeme-solaire.net/en/)
endpoint.
It fetches the solar bodies and keeps a local SQLite cache up to date.

Note: The example requires Swift 5.7 / Xcode 14b for proper plugin support.


### Overview

The example in a nutshell. The source just demonstrates the concepts (e.g. 
lacks error handlers), check the sources for the real implementation.

This is an example where the target doesn't import an existing database (like
Northwind), but rather defines an own database schema, which is then used as
a very fast local cache. Offline first.

The database schema is defined as a SQL source file that is part of the 
Xcode target,
[BodiesDB-001.sql](Sources/Bodies/BodiesDB-001.sql):
```
CREATE TABLE solar_body (
    id             TEXT NOT NULL PRIMARY KEY,
    name           TEXT NOT NULL,
    english_name   TEXT NOT NULL,
    body_type      TEXT NOT NULL,
    densitity      REAL,
    gravity        REAL,
    discovered_by  TEXT,
    discovery_date TEXT
);
```
> The SQL files do not have to be included as app resources.
> But they can, e.g. if required for migration.
> Enlighter can generate Swift from any combination of binary database or SQL
> files.

In the SwiftUI 
[application struct](Sources/Bodies/BodiesApp.swift) 
the cache database is bootstrapped from the SQL schema and passed down to the
[`ContentView`](Sources/Bodies/ContentView.swift) 
ContentView.
```swift
@main
struct BodiesApp: App {
    
    let database = try BodiesDB.bootstrap()
  
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(database: database)
                    .navigationTitle("Solar Bodies")
            }
        }
    }
}
```

The [ContentView](Sources/Bodies/ContentView.swift) is just a simple SwiftUI
[`List`](https://developer.apple.com/documentation/swiftui/list)
w/ support for searching and pull-to-refresh.
It does all the magic though:
```swift
struct ContentView: View {
    
    let database : BodiesDB // passed in from the app
    
    @State private var bodies : [ SolarBody ] = []

    /// The current search string.
    @State private var searchString = ""
    
    @MainActor
    func loadFromCache() async {
        bodies = try await database.solarBodies.fetch(orderBy: \.englishName) {
            $0.englishName.contains(searchString, caseInsensitive: true)
        }
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
            } icon: { Image(systemName: "globe") }
        }
        .searchable(text: $searchString)
        .refreshable {
            Task.detached { try await fetchAndUpdateCache() }
        }
        .task(id: searchString) { // also run on startup
            await loadFromCache()
        }
        .task { // start the regular refresh sync in background
            Task.detached(priority: .background) {
                try await fetchAndUpdateCache()
            }
        }
    }
    
    private func fetchAndUpdateCache() async throws {
        let url = URL(string: "https://api.le-systeme-solaire.net/rest/bodies")!
        let ( data, _ ) = try await URLSession.shared.data(from: url)
        struct Result: Decodable {
            let bodies : [ SolarBody ]
        }
        let result = try JSONDecoder().decode(Result.self, from: data)
        
        let oldIDs = Set(try await database.select(from: \.solarBodies, \.id))
        
        let idsToDelete     = oldIDs.subtracting(result.bodies.map(\.id))
        let recordsToUpdate = result.bodies.filter {  oldIDs.contains($0.id) }
        let recordsToInsert = result.bodies.filter { !oldIDs.contains($0.id) }

        try await database.transaction { tx in
            try tx.delete(from: \.solarBodies, where: { $0.id.in(idsToDelete) })
            try tx.update(recordsToUpdate)
            try tx.insert(recordsToInsert)
        }
        
        await loadFromCache() // reload
    }
}
```

### Screenshot

<img width="534" alt="Screenshot 2022-08-12 at 16 05 09" src="https://user-images.githubusercontent.com/7712892/184907841-f0aec194-1b60-42c7-a300-561f3349e5ef.png">


### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.
