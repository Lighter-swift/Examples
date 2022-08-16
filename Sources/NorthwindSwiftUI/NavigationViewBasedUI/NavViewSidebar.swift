import SwiftUI

@available(iOS,   introduced: 13.0,  deprecated: 16.0)
@available(macOS, introduced: 10.15, deprecated: 13.0)
extension NavView {
  
  struct Sidebar: View {
    
    private enum Section: String {
      case products
    }
    
    @State private var section : Section? = .products
    
    var body: some View {
      List {
        NavigationLink(destination: ProductsList(),
                       tag: Section.products, selection: $section)
        {
          Label("Products", systemImage: "p.circle")
            .font(.title2)
        }
        
        Spacer()
      }
    }
  }
}
