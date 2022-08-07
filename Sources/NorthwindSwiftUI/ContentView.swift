import SwiftUI
import Northwind

struct ContentView: View {
    
  var body: some View {
    NavigationView {
      Sidebar()
      
      ProductsList()
      
      ZStack {
        Text("Nothing Selected")
          .font(.title)
          .foregroundColor(.accentColor)
      }
      .layoutPriority(2)
    }
    .frame(minWidth: 640, minHeight: 340)
  }
}
