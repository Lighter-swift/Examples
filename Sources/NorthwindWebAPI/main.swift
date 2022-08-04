#!/usr/bin/swift sh

import MacroExpress // @Macro-swift
import Northwind    // @Lighter-swift/NorthwindSQLite.swift

let db  = Northwind.module!
let app = express()

// curl http://localhost:1337/products | jq .
app.get("/products") { _, res, _ in
  res.send(try db.products.fetch())
}

// MARK: - Start Server
app.listen(1337) {
  console.log("Server listening on http://localhost:1337")
}
