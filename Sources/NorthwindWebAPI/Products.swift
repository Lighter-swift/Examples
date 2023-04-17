import MacroExpress
import Northwind

/// This is the endpoint which drives the products.html page.
func products(req: IncomingMessage, res: ServerResponse, next: Next) throws {
  // We can track fetch limits using a query parameters
  req.body = .urlEncoded(req.query)
  let limit = req.body[int: "limit"] ?? 10

  //let limit = req.query["limit"] as? Int ?? 10
  //print("Q:", limit, req.query)
  
  // This asks lighter to fetch all product infos we have.
  // Note: Xcode allows an option-click on "Products" to show information about
  //       the type, or control-click to jump to the code.
  let products : [ Product ] = try db.products.fetch(limit: limit)
  res.log.log("Fetched: #\(products.count) products!")
  
  
  // The first "products" refers to the "views/products.html" Mustache
  // template.
  // We pass over a dictionary that will be made available to the template.
  res.render("products", [
    "products"       : products,
    "limit"          : limit,
    "lowerLimit"     : (limit - 10) > 1 ? (limit - 10) : 1,
    "higherLimit"    : limit + limit
  ] as [String : Any])
}

/// This is the endpoint which drives the page for a single product.
func product(req: IncomingMessage, res: ServerResponse, next: Next) throws {
  // Extracts the "id" from the route path (e.g. `/products/12`)
  guard let id = req.params[int: "id"] else {
    res.statusCode = 400
    return res.send("Did not find valid product ID!")
  }
  
  // First lookup the product record by primary key. `id` is an `Int`.
  guard let product = try db.products.find(id) else {
    res.statusCode = 404
    return res.send("Did not find product for ID \(id)!")
  }

  var templateVariables : [ String : Any ] = [
    "product": product
  ]

  // Then fetch related objects. The Product table in SQLite has associated
  // foreign keys, and Lighter synthesizes accessors for those.

  if let supplier = try db.suppliers .find(for: product) {
    templateVariables["supplier"] = supplier
  }
  if let category = try db.categories.find(for: product) {
    templateVariables["category"] = category
    if let picture = category.picture, !picture.isEmpty {
      let base64 = Buffer(picture).data.base64EncodedString()
      templateVariables["categoryPicture"] = base64
    }
  }
  
  res.render("product", templateVariables)
}
