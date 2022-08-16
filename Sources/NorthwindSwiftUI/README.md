<h2>Lighter Example: Northwind SwiftUI App
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

A SwiftUI example that accesses the Northwind database. It displays
the products and allows simple editing operations.

IMPORTANT: 
This is NOT a demo on how to structure a SwiftUI application.
It doesn't make use of proper concepts like
[ViewController](http://www.alwaysrightinstitute.com/viewcontroller/)s,
but keeps everything in local states.

Note: The example requires Swift 5.7 / Xcode 14b for proper plugin support.

Northwind API: [Documentation](https://55db091a-8471-447b-8f50-5dff4c1b14ac.github.io/NorthwindSQLite.swift/documentation/northwind/)



### Overview

The example in a nutshell. The source just demonstrates the concepts (e.g. 
lacks error handlers), check the sources for the real implementation.

> The example has to implementations: The main one is for iOS 16 and 
> macOS Ventura and uses the new
>  [`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview).
> A subfolder contains a `NavigationView` variant that works well on
> macOS 12.

In the SwiftUI 
[application struct](Sources/NorthwindSwiftUI/NorthwindApp.swift) 
the `Northwind` database is bootstrapped by copying the database file embedded
in the Northwind package.
The database struct is then passed down to the views in the SwiftUI environment.
```swift
@main
struct NorthwindApp: App {

  let database = try Northwind.bootstrap(
    copying: Northwind.module.connectionHandler.url
  )
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.database, database)
    }
  }
}
```

The [ContentView](Sources/NorthwindSwiftUI/MainView.swift) is just a three-pane
[`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview):
```swift
struct ContentView: View {

  @State private var section           : Section?    = .products
  @State private var products          : [ Product ] = []
  @State private var selectedProductID : Product.ID?
  
  var body: some View {
    NavigationSplitView(
      sidebar: { Sidebar(section: $section) },
      content: { 
        ProductsList(products: $products,
                     selectedProduct: $selectedProductID)
      },
      detail: {
        ProductPage(snapshot: product, onSave: updateSavedProduct)
      }
    )
  }
}
```

The database is eventually accessed in the
[`ProductList`](Sources/NorthwindSwiftUI/ProductList.swift),
a SwiftUI View using a
[`List`](https://developer.apple.com/documentation/swiftui/list)
to display the fetched products.
The products are fetched using the
[`.task`](https://swiftwithmajid.com/2022/06/28/the-power-of-task-view-modifier-in-swiftui/)
modifier:
```swift
@available(iOS 16.0, macOS 13, *)
struct ProductsList: View {
  @Environment(\.database) private var database
  @Binding var products        : [ Product ]
  @Binding var selectedProduct : Product.ID?

  @State private var searchString = ""
    
  var body: some View {
    List(products, selection: $selectedProduct) {
      ProductCell(product: $0)
    }
    .searchable(text: $searchString)
    .task(id: searchString) {
      products = try await database.products.fetch(orderBy: \.productName) {
        $0.productName.contains(
          searchString.trimmingCharacters(in: .whitespacesAndNewlines),
          caseInsensitive: true
        )
      }
    }
  }
}
```

An example for record updates can be found in the
[`ProductPage`](Sources/NorthwindSwiftUI/ProductPage.swift) View.
Database records are always Equatable and Hashable (because they are just
values in a SQLite database), so it is easy to check whether there are
changes to be saved.
```swift
struct ProductPage: View {
  @Environment(\.database) private var database

                 let snapshot : Product
  @State private var product  : Product = Product(id: 0, productName: "")

  private var hasChanges : Bool {
    snapshot != product
  }

  var body: some View {
    Form {
      ProductForm(product: $product)
    }
    .onChange(of: snapshot) { product = $0 }
    .onAppear               { product = $0 }
    .toolbar {
      ToolbarItem(placement: .destructiveAction) {
        Button("Revert") { product = snapshot }
          .disabled(!hasChanges)
      }
      ToolbarItem(placement: .confirmationAction) {
        Button("Save") {
          try database.update(product)
        }
        .disabled(!hasChanges)
      }
    }
  }
}
```

### Screenshot

<img width="1014" alt="Screenshot 2022-08-16 at 16 41 31" src="https://user-images.githubusercontent.com/7712892/184908144-22cf9a9a-7901-4815-9453-61d8602a093f.png">


### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.
