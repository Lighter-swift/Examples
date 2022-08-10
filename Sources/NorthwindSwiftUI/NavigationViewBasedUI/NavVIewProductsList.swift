import SwiftUI
import Northwind

@available(iOS,   introduced: 13.0,  deprecated: 16.0)
@available(macOS, introduced: 10.15, deprecated: 13.0)
extension NavView {
  
  struct ProductsList: View {

    /// The database is passed down by the App struct in the environment.
    @Environment(\.database) private var database
    
    /// In this state we keep the list of currently fetched products.
    @State private var products : [ Product ] = []
    
    /// We track the currently selected product
    @State private var selectedProduct : Product.ID?
    
    /// For current search string
    @State private var searchString = ""
    
    private func updateSavedProduct(_ product: Product) {
      guard let idx = products.firstIndex(where: { $0.id == product.id }) else {
        return // not in the list?
      }
      products[idx] = product
    }
    
    var body: some View {
      List {
        ForEach(products) { product in
          NavigationLink(
            destination: ProductPage(snapshot: product,
                                     onSave: updateSavedProduct),
            tag: product.id, selection: $selectedProduct
          )
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
      
      #if os(macOS)
        // Doesn't update without? (i.e. the one attached to the item is ignored)
        .navigationTitle(selectedProduct.flatMap { selectedID in
          products.first { $0.id == selectedID }?.productName
        } ?? "Products")
      #else
        .navigationTitle("Products")
      #endif
    }
  }
}
