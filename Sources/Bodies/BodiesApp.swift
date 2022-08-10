import SwiftUI

@main
struct BodiesApp: App {
  
    // Bootstrap the database in the "Application Support" folder.
    // "overwrite" can be used during development to get a clean database on
    // each run.
    #if DEBUG
    let database = try! BodiesDB.bootstrap(overwrite: true)
    #else
    let database = try! BodiesDB.bootstrap()
    #endif
  
    var body: some Scene {
        WindowGroup {
            NavigationView { // just for the visual styling
                ContentView(database: database)
                    .navigationTitle("Solar Bodies")
            }
        }
    }
}
