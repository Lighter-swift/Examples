import SwiftUI

@available(iOS,   introduced: 13.0,  deprecated: 16.0)
@available(macOS, introduced: 10.15, deprecated: 13.0)
extension NavView {
  
  struct MainView: View {
      
    var body: some View {
      NavigationView {
        
        // Column 1
        Sidebar()
        
        // Column 2
        ProductsList()
        
        // Column 3
        ZStack {
          Text("Nothing Selected")
            .font(.title)
            .foregroundColor(.accentColor)
        }
        .layoutPriority(2)
      }
    }
  }
}
