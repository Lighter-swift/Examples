<h2>Lighter Example: Northwind Web API
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

A server side swift example for accessing the Northwind database
using a JSON API and providing a view HTML views to browse them.

Note: The example requires Swift 5.7 / Xcode 14b for proper plugin support.

The example is using the 
[MacroExpress](https://github.com/Macro-swift/MacroExpress)
framework, which is like Node.js/Express.js for Swift.

It demonstrates two things:
- Directly mapping [SQLite](https://www.sqlite.org/index.html) table records
  to JSON APIs using
  [Codable](https://developer.apple.com/documentation/swift/codable).
  (Including automatic endpoint generation based on the static type 
   information.)
- Using [SQLite](https://www.sqlite.org/index.html) table records in
  [Mustache](http://mustache.github.io) for rendering.

This example works as a plain Swift Package Manager tool or as an Xcode
tool target.

Northwind API: [Documentation](https://55db091a-8471-447b-8f50-5dff4c1b14ac.github.io/NorthwindSQLite.swift/documentation/northwind/)

### Running the Example

Either open Package.swift or the xcodeproj in Xcode, select the
`NorthwindWebAPI` tool scheme and press run.

Or on the shell:
```bash
$ swift run NorthwindWebAPI
```

The example can then be accessed at
[http://localhost:1337/](http://localhost:1337/).


### Overview

The example in a nutshell:
```swift
#!/usr/bin/swift sh
import MacroExpress // @Macro-swift
import Northwind    // @Northwind-swift/NorthwindSQLite.swift

// Get a handle to the database
let db  = Northwind.module!
// Setup the app server
let app = express()
  .use(logger("dev"))
  .set("view engine", "html")
  .set("views", __dirname() + "/views")

// Map `/api/products` to a handler which fetches all "products" from the DB.
// Access using: curl http://localhost:1337/api/products | jq .
app.get("/api/products") { _, res in
  res.send(try db.products.fetch())
}

// We can also autogenerate endpoints for each table automagically.
app.get(db, prefix: "/api/")

app // Those hook up the HTML pages/templates.
  .get("/products.html", products)
  .get("/products/:id/", product)
  .get("/") { _, res in res.render("index") }

app.listen(1337) // start server
```

### Screenshots

<img width="890" alt="MacroSample-Product-List" src="https://user-images.githubusercontent.com/7712892/184907723-f76691b2-a0bf-4c04-b866-55599603afa4.png">
<img width="890" alt="Macro-Sample-Product-Detail" src="https://user-images.githubusercontent.com/7712892/184907762-cead2c35-1e80-49ce-a5c6-d3522d145411.png">

### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.
