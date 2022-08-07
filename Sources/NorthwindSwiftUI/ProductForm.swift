import SwiftUI
import Northwind

/**
 * A SwiftUI Form to edit the product columns.
 */
struct ProductForm: View {
  
  @Binding var product : Product
    
  var body: some View {
    Form {
      Section("Product Information") {
        
        TextField("Product Name", text: $product.productName)
          .help("The name of the product, choose wisely.")
        
        TextField("Price per Unit", value: $product.unitPrice,
                  format: .currency(code: "USD"))
          .help("The price of a single unit, in USD.")
        
        TextField("Quantity per Unit", value: $product.quantityPerUnit,
                  formatter: .emptyIsNull)
          .help("Describe the contents of a unit, e.g. '10 boxes x 20 bags'.")
      }
      
      Section("Stock") {
        
        TextField("Units in Stock", value: $product.unitsInStock,
                  format: .number)
          .help("The number of units we have in stock.")
        
        TextField("Units on Order", value: $product.unitsOnOrder,
                  format: .number)
          .help("The number of units we have ordered.")
        
        TextField("Reorder Level", value: $product.reorderLevel,
                  format: .number)
        
        // Northwind just uses a string for this, should be made a BOOL
        // column in the database.
        Toggle("Discontinued", isOn: Binding(
          get: { product.discontinued != "0" },
          set: { product.discontinued = $0 ? "1" : "0" }
        ))
      }
    }
  }
}
