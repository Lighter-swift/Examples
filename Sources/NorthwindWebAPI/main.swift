#!/usr/bin/swift sh

import MacroExpress // @Macro-swift
import Northwind    // @Lighter-swift/NorthwindSQLite.swift

dotenv.config()

let db  = Northwind.module! // This grabs the read-only DB embedded in the pkg
let app = express()

app.use(logger("dev"))
app.use(bodyParser.urlencoded())
app.set("view engine", "html")
app.set("views", __dirname() + "/views")


// MARK: - Setup Routes

// This is an explicit registration for a specific record fetch.
// curl http://localhost:1337/api/products | jq .
app.get("/api/products") { _, res, _ in
  res.send(try db.products.fetch())
}

// But w/ 5.7+ we can also dynamically register the typesafe handlers.
// curl http://localhost:1337/api/Supplier | jq .
app.get(db, prefix: "/api/")


// Those hook up the HTML pages/templates.
app
  .get("/products.html", products)
  .get("/products/:id/",  product)

app.get("/") { _, res, _ in
  res.render("index")
}


// MARK: - Open URL in Browser in startup

#if DEBUG && os(macOS) && canImport(AppKit)
  import AppKit
  setTimeout(100) {
    NSWorkspace.shared.open(URL(string: "http://localhost:1337/")!)
  }
#endif


// MARK: - Start Server

app.listen(1337) {
  console.log("Server listening on http://localhost:1337")
}
