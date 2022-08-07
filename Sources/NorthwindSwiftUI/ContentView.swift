import SwiftUI
import Northwind

struct ContentView: View {

  @StateObject private var products = DataSource(Northwind.module.products)
    
  var body: some View {
    List {
      ForEach(products.items) { record in
        Text(verbatim: "\(record)")
      }
    }
    .task {
      try! await products.fetch()
    }
    .frame(minWidth: 640, minHeight: 340)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
