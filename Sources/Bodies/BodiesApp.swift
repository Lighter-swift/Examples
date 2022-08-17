import SwiftUI

@main
struct BodiesApp: App {
  
    // Bootstrap the database in the "Application Support" folder.
    // "overwrite" can be used during development to get a clean database on
    // each run.
    #if DEBUG
    let database =
        try! BodiesDB.bootstrap(into: .cachesDirectory, overwrite: true)
    #else
    let database = try! BodiesDB.bootstrap(into: .cachesDirectory)
    #endif
    
    init() {
        // Check whether a migration is necessary.
        let schemaVersion =
            try! database.get(pragma: "user_version", as: Int.self)
        if schemaVersion != BodiesDB.userVersion {
            try! database.fetch("UPDATE") { _, _ in }
            
            print("Dumping cache, the version is outdated.")
            _ = try! BodiesDB.bootstrap(overwrite: true)
        }
    }
  
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
                ContentView(database: database)
                    .frame(width: 440) // just fix it
                    .navigationTitle("Solar Bodies")
            #else // iOS
                NavigationView { // just for the visual styling
                    ContentView(database: database)
                        .navigationTitle("Solar Bodies")
                }
            #endif
        }
        #if os(macOS)
        .windowStyle(.titleBar)
        #endif
    }
}
