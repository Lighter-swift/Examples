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

The example in a nutshell:
```swift
#!/usr/bin/swift sh
import MacroExpress // @Macro-swift
import Northwind    // @Lighter-swift/NorthwindSQLite.swift

// Get a handle to the database
let db  = Northwind.module!
// Setup the app server
let app = express()
  .use(logger("dev"))
  .set("view engine", "html")
  .set("views", __dirname() + "/views")

// Map `/api/products` to a handler which fetches all "products" from the DB.
// Access using: curl http://localhost:1337/api/products | jq .
app.get("/api/products") { _, res, _ in
  res.send(try db.products.fetch())
}

// We can also autogenerate endpoints for each table automagically.
app.get(db, prefix: "/api/")

app // Those hook up the HTML pages/templates.
  .get("/products.html", products)
  .get("/products/:id/", product)
  .get("/") { _, res, _ in res.render("index") }

app.listen(1337) // start server
```


### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

**Want to support my work**?
Buy an app:
[Past for iChat](https://apps.apple.com/us/app/past-for-ichat/id1554897185),
[SVG Shaper](https://apps.apple.com/us/app/svg-shaper-for-swiftui/id1566140414),
[Shrugs](https://shrugs.app/),
[HMScriptEditor](https://apps.apple.com/us/app/hmscripteditor/id1483239744).
You don't have to use it! 😀
