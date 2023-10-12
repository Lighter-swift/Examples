import SwiftUI
import Northwind
import Lighter
import SQLite3

/// Global application state. A good place to setup the database object.
@main
struct NorthwindApp: App {
  
  let database = (try? Northwind.bootstrap(
    copying: Northwind.module.connectionHandler.url
  )) ?? .module!
    
  init() {
    lowlevelTests()
    if #available(iOS 16, *) {
      try! regexTests()
    }
  }
  
  @available(iOS 16, *)
  private func regexTests() throws {
    // https://unicode-org.github.io/icu/userguide/strings/regexp.html
    let products = try database.products.filter {
      $0.productName.wholeMatch(of: /^\w+\s+\w+$/) != nil
    }
    print("Products:", products.map(\.productName))
  }
  
  private func lowlevelTests() {
    let url = database.connectionHandler.url
    var db : OpaquePointer?
    let rc = sqlite3_open_v2(
      url.absoluteString, &db,
      SQLITE_OPEN_READONLY | SQLITE_OPEN_URI, nil
    )
    assert(rc == SQLITE_OK)
    defer {
      sqlite3_close(db)
    }
    
    let _/* allProducts*/ = sqlite3_products_fetch(db)

    guard let products = sqlite3_products_fetch(
      db, sql:
      """
      SELECT ProductId, ProductName, QuantityPerUnit FROM Products
       WHERE QuantityPerUnit LIKE '%boxes%'
      """,
      filter: { _ in true }
    ) else {
      let error = SQLError(db)
      fatalError("FETCH FAILED: \(error)")
    }
    print("Products: #\(products.count)")
   // products.first?.discontinued
    
    var statement : OpaquePointer?
    let rc2 = sqlite3_prepare_v2(
      db,
      """
      SELECT ProductId, ProductName, QuantityPerUnit FROM Products
       WHERE QuantityPerUnit LIKE ?
      """,
      -1, &statement, nil
    )
    assert(rc2 == SQLITE_OK)
    defer { sqlite3_finalize(statement) }

    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type?.self)

    sqlite3_bind_text(statement, 1, "%boxes%", -1, SQLITE_TRANSIENT)
        
    //let indices = Product.Schema.lookupColumnIndices(in: statement)
    var records = [ ( id: Int, name: String ) ]()
    while sqlite3_step(statement) == SQLITE_ROW {
      let product = Product(statement)
      //let product = Product(statement, indices: indices)
      records.append( ( id: product.id, name: product.productName ) )
    }
    print("RECORDS: #\(records.count)")
    
    // Abuse it by renaming :-)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.database, database)
      #if os(macOS)
        .frame(minWidth: 640, minHeight: 340)
      #endif
    }
  }
}


// MARK: - Environment Keys

extension EnvironmentValues {
  
  private struct DatabaseKey: EnvironmentKey {
    static let defaultValue = Northwind.module!
  }
  
  /// Provide the Database object to the Views using the environment
  var database : Northwind {
    set { self[DatabaseKey.self] = newValue }
    get { self[DatabaseKey.self] }
  }
}


// MARK: - Custom Formatters

/// This is a simple formatter that can take optional Strings, turn them into
/// empty ones, and the reverse.
final class EmptyStringIsNullFormatter: Formatter {
  
  override func string(for value: Any?) -> String? {
    (value as? String) ?? ""
  }
  
  override func getObjectValue(
    _ value: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
    for string: String,
    errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool
  {
    value?.pointee = string.isEmpty ? nil : string as NSString
    return true
  }
}

extension Formatter {
  static let emptyIsNull = EmptyStringIsNullFormatter()
}
