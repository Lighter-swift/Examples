import SwiftUI
import Northwind

struct SupplierForm: View {
  
  @Binding var supplier : Supplier
  
  var body: some View {
    Section("Supplier Information") {
      
      TextField("Supplier Name", text: $supplier.companyName)
      
      TextField("Address", value: $supplier.address,
                formatter: .emptyIsNull)
      TextField("City", value: $supplier.city,
                formatter: .emptyIsNull)
      TextField("Region", value: $supplier.region,
                formatter: .emptyIsNull)
      TextField("Postal Code", value: $supplier.postalCode,
                formatter: .emptyIsNull)
      TextField("Country", value: $supplier.country,
                formatter: .emptyIsNull)
    }
    Section("Supplier Contact") {

      TextField("Contact Name", value: $supplier.contactName,
                formatter: .emptyIsNull)
      TextField("Contact Title", value: $supplier.contactTitle,
                formatter: .emptyIsNull)

      TextField("Phone", value: $supplier.phone,
                formatter: .emptyIsNull)
      TextField("Fax", value: $supplier.fax,
                formatter: .emptyIsNull)
      TextField("Homepage", value: $supplier.homePage,
                formatter: .emptyIsNull)
    }
  }
}
