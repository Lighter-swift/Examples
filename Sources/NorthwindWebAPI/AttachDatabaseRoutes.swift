import MacroExpress
import Northwind
import Lighter

#if swift(>=5.7)
extension RouteKeeper {
  
  /**
   * Add a retrieval functions for all the Codable entities in the database.
   */
  func get<T: SQLDatabase>(_ db: T, prefix: String = "/api/") {
    for type in T._allRecordTypes {
      guard let codableType = type as? any (SQLRecord & Codable).Type else {
        console.trace("Skipping non-codable Record:", type)
        continue
      }
      
      let name = String(describing: type)
      
      #if false // This needs to be constrained on the type to work, possible
      if let keyedType = type as? any (SQLKeyedTableRecord & Codable).Type {
        registerRecordFind(for: keyedType, in: db, name: name, prefix: prefix)
      }
      #endif
      
      registerRecordFetch(for: codableType, in: db, name: name, prefix: prefix)
    }
  }
  
  private func registerRecordFetch<DB, T>(for type: T.Type, in db: DB,
                                          name: String, prefix: String)
    where T: SQLRecord & Codable, DB: SQLDatabase
  {
    console.trace("Register:", "\(prefix)\(name)")
    add(route: .init(
      id: name + ".fetch", pattern: "\(prefix)\(name)", method: .GET,
      middleware: [
        { req, res, next in
          let op = SQLRecordFetchOperations<DB, T>(db)
          res.send(try op.fetch())
        }
      ]
    ))
  }

  private func registerRecordFind<DB, T>(for type: T.Type, in db: DB,
                                         name: String, prefix: String)
    where T: SQLKeyedTableRecord & Codable, DB: SQLDatabase,
          T.ID == Int
  {
    console.trace("Register:", "\(prefix)\(name)/:id")
    add(route: .init(
      id: name + ".find", pattern: "\(prefix)\(name)/:id", method: .GET,
      middleware: [
        { req, res, next in
          guard let id = req.params[int: "id"] else {
            res.statusCode = 400
            return res.send("Did not find valid record!")
          }
          
          let op = SQLRecordFetchOperations<DB, T>(db)
          guard let record = try op.find(id) else {
            res.statusCode = 404
            return res.send("Did not find record for ID \(id).")
          }
          
          res.send(record)
        }
      ]
    ))
  }

}
#endif // Swift 5.7+
