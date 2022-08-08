import SwiftUI
import Northwind

struct ProductPage: View {

  /// The database is passed down by the Application struct in the environment.
  @Environment(\.database) private var database

  /// The snapshot is the current value that got fetched from the database
  let snapshot : Product
  
  /// This is used to tell the list about a change we did. I.e. a save.
  /// In a real app there should be more app structure around this, but that
  /// won't be "Lighter", but "Heavier" (stay tuned™️).
  let onSave : ( Product ) -> Void
  
  /// If we allow editing, we can keep a copy of the snapshot for that purpose.
  @State private var product  : Product = Product(id: 0, productName: "")

  @State private var supplier : Supplier?
  @State private var category : NorthwindCategory?

  /// Since SQLite records are by definition equatable, we can just compare the
  /// full record for changes.
  private var hasChanges : Bool {
    snapshot != product
  }
  
  func setup() async {
    do {
      // We also fetch the supplier and category info using the relationship
      // features of Lighter/Enlighter.
      // Those can be run concurrently (even though it doesn't give much here,
      // for demo purposes only). We can use `async let` for this.
      async let supplier = database.suppliers.find(for: product)
      async let category = database.categories.find(for: product)
      ( self.supplier, self.category ) = try await ( supplier, category )
    }
    catch { // Invest the time for proper error handling...
      print("ERROR: Failed to fetch a relationship.")
    }
  }
  
  /// Revert changes
  private func revert() {
    product = snapshot
  }
  
  private func save() async {
    do {
      // While not required, it is always a good idea to update in an
      // transaction as this ensures order and consistency.
      try await database.transaction { tx in
        try tx.update(product)
        // we always save, this, demo only.
        if let supplier = supplier { try tx.update(supplier) }
      }
      await MainActor.run {
        // tell the parent view that the record got modified
        self.onSave(product)
      }
    }
    catch {
      print("ERROR: failed to save:", error)
    }

  }
    
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Spacer()
        Text(product.productName)
          .font(.title)
        Spacer()
      }
      .padding()
      .background(alignment: .trailing) {
        Text("Edited")
          .font(.footnote)
          .foregroundColor(.red)
          .opacity(hasChanges ? 1.0 : 0.0)
          .padding()
      }
      
      Divider()
      
      ScrollView {
        ProductForm(product: $product)
          .padding()

        if let category = category {
          Divider()
          CategoryInfo(category: category)
        }

        if let supplier = supplier {
          Divider()
          SupplierForm(supplier: Binding( // deal with the nil value
            get: { supplier }, set: { self.supplier = $0 }
          ))
          .padding([ .horizontal, .bottom ])
        }
        
        Spacer()
      }

    }
    .task { await setup() }
    .onAppear {
      // If the view loads, make a copy of the fetched record for editing.
      product = snapshot
    }
    .toolbar {
      ToolbarItem(placement: .destructiveAction) {
        Button(action: revert) {
          Label("revert", systemImage: "arrow.counterclockwise")
        }
        .keyboardShortcut("r", modifiers: [ .command ])
        .help("Revert changes made to the record.")
        .disabled(!hasChanges)
      }
      ToolbarItem(placement: .confirmationAction) {
        Button(action: { Task { await self.save() } }) {
          Label("save", systemImage: "s.circle")
        }
        .keyboardShortcut("s", modifiers: [ .command ])
        .help("Save changes made to the record.")
        .disabled(!hasChanges)
      }
    }
  }
}
