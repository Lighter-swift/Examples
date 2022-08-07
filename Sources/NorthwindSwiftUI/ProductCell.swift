import SwiftUI
import Northwind

/**
 * A tableview cell for a product. I.e. a view suitable to show Product
 * information in a `List`.
 */
struct ProductCell: View {
  
  let product : Product
  
  // Incorrectly marked NULLable in Northwind
  private var unitsInStock : Int { product.unitsInStock ?? 0 }
  
  var body: some View {
    Label(
      title: {
        VStack(alignment: .leading) {
          Text(verbatim: product.productName)
            .font(.headline)
          
          HStack(spacing: 0) {
            Text(product.unitPrice ?? 0, format: .currency(code: "USD"))
            if unitsInStock > 0 {
              Text(", \(unitsInStock) in stock")
            }
            else if product.discontinued != "0" {
              Text(", discontinued")
                .foregroundColor(.red)
            }
            else {
              Text(", out of stock.")
                .foregroundColor(.red)
              if let ordered = product.unitsOnOrder, ordered > 0 {
                Text(", ordered \(ordered)")
              }
            }
          }
          
          if unitsInStock > 0 && product.discontinued != "0" {
            Text("Discontinued")
              .foregroundColor(.red)
          }
        }
      },
      icon: { Image(systemName: "p.circle") }
    )
  }
}
