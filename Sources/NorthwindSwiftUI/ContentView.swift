import SwiftUI
import Northwind

struct ContentView: View {
    
  var body: some View {
    if #available(iOS 16, macOS 13, *) {
      MainView()
    }
    else {
      NavView.MainView()
    }
  }
}
