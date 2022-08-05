#!/usr/bin/swift sh

import MacroExpress // @Macro-swift
import Northwind    // @Lighter-swift/NorthwindSQLite.swift

dotenv.config()

let db  = Northwind.module!
let app = express()

app.use(logger("dev"))
app.use(bodyParser.urlencoded())
app.set("view engine", "html")
app.set("views", __dirname() + "/views")

// curl http://localhost:1337/api/products | jq .
app.get("/api/products") { _, res, _ in
  res.send(try db.products.fetch())
}

app
  .get("/products.html", products)
  .get("/products/:id/",  product)

app.get("/") { _, res, _ in
  res.render("index")
}

// MARK: - Start Server
app.listen(1337) {
  console.log("Server listening on http://localhost:1337")
}
