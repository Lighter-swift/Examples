import SwiftUI
import Northwind

@available(iOS 16.0, macOS 13, *)
extension MainView: View {
  
  struct Sidebar: View {
    
    @Binding var section : Section?
    
    var body: some View {
      List(selection: $section) {
        Label("Products", systemImage: "p.circle")
          .font(.title2)
          .tag(Section.products)
      }
      .navigationTitle("Northwind")
    }
  }
}
