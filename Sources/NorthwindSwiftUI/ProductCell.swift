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

          detailText
        }
      },
      icon: { Image(systemName: "p.circle") }
    )
  }
    
  var detailText : Text {
    var text = Text(product.unitPrice ?? 0, format: .currency(code: "USD"))
      
    if unitsInStock > 0 {
      text = text + Text(", \(unitsInStock) in stock")
    }
    else {
      text = text + Text(", ")
      text = text + Text("out of stock").foregroundColor(.red)
      if let ordered = product.unitsOnOrder, ordered > 0 {
        text = text + Text(", ordered \(ordered)")
      }
    }
    
    if product.discontinued != "0" {
      text = text + Text(", ")
      text = text + Text("discontinued").foregroundColor(.red)
    }
    return text
  }
}
