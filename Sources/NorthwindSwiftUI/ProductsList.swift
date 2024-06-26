import SwiftUI
import Northwind

@available(iOS 16.0, macOS 13, *)
struct ProductsList: View {

  /// The database is passed down by the Application struct in the environment.
  @Environment(\.database) private var database
  
  /// The products are passed in as a binding, as the detail needs to
  /// communicate with it.
  @Binding var products : [ Product ]
  
  /// We track the currently selected product
  @Binding var selectedProduct : Product.ID?
  
  /// The current search string.
  @State private var searchString = ""

  #if !os(macOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  #endif

  var body: some View {
    List(products, selection: $selectedProduct) { product in
      ProductCell(product: product)
    }
    .searchable(text: $searchString)
    .task(id: searchString) {
      do {
        // Here we are using a query builder to filter by column. Alternatively
        // one can use an arbitrary Swift closure using `filter`.
        let searchString = searchString // strict concurrency
        products = try await database.products.fetch(orderBy: \.productName) {
          $0.productName.contains(
            searchString.trimmingCharacters(in: .whitespacesAndNewlines),
            caseInsensitive: true
          )
        }
        
        // Pre-select the first match if none is selected.
        #if os(macOS)
          if selectedProduct == nil, let product = products.first {
            selectedProduct = product.id
          }
        #else
          if horizontalSizeClass != .compact { // this waits for the tap
            if selectedProduct == nil, let product = products.first {
              selectedProduct = product.id
            }
          }
        #endif
      }
      catch { // really, do proper error handling :-)
        print("Fetch failed:", error)
      }
    }
    .navigationTitle("Products")
  }
}
