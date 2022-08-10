import SwiftUI
import Northwind

@available(iOS 16.0, macOS 13, *)
struct MainView: View {

  enum Section: String {
    case products
  }
  enum Detail {
    case product(Product)
  }
  
  /// The active section in the sidebar
  @State var section : Section? = .products

  /// The array of products that got fetched
  @State private var products : [ Product ] = []

  /// We track the currently selected product
  @State var selectedProductID : Product.ID?

  
  private var selectedProduct : Product? {
    selectedProductID.flatMap { id in products.first(where: { $0.id == id })}
  }
  
  private func updateSavedProduct(_ product: Product) {
    guard let idx = products.firstIndex(where: { $0.id == product.id }) else {
      return // not in the list?
    }
    products[idx] = product
  }
  

  var body: some View {
    NavigationSplitView(
      
      sidebar: {
        Sidebar(section: $section)
      },
      
      content: {
        switch section {
          case .products:
            ProductsList(products: $products,
                         selectedProduct: $selectedProductID)
          
          case .none:
            Text("No section is selected")
        }
      },
      
      detail: {
        if let product = selectedProduct {
          ProductPage(snapshot: product, onSave: updateSavedProduct)
        }
        else {
          Text("Nothing Selected")
            .font(.title)
            .foregroundColor(.accentColor)
        }
      }
    )
  }
}
