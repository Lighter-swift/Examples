import SwiftUI
import Northwind

struct ProductsList: View {

  /// The database is passed down by the Application struct in the environment.
  @Environment(\.database) private var database
  
  /// In this state we keep the list of currently fetched products.
  @State private var products : [ Product ] = []
  
  /// We track the currently selected product
  @State private var selectedProduct : Product.ID?
  
  /// For current search string
  @State private var searchString = ""
    
  var body: some View {
    List {
      ForEach(products) { product in
        NavigationLink(destination: ProductPage(snapshot: product),
                       tag: product.id, selection: $selectedProduct)
        {
          ProductCell(product: product)
        }
      }
    }
    .searchable(text: $searchString)
    .task(id: searchString) {
      
      do {
        // Here we are using a query builder to filter by column. Alternatively
        // one can use an arbitrary Swift closure using `filter`.
        products = try await database.products.fetch(orderBy: \.productName) {
          $0.productName.contains(
            searchString.trimmingCharacters(in: .whitespacesAndNewlines),
            caseInsensitive: true
          )
        }
        
        // Pre-select the first match if none is selected
        if selectedProduct == nil, let product = products.first {
          selectedProduct = product.id
        }
      }
      catch { // really, do proper error handling :-)
        print("Fetch failed:", error)
      }
    }
  }
}
