import Foundation
import SwiftUI
import Northwind

extension NorthwindCategory {
  
  // This is an example of a custom mapping, which can be done in extensions
  // if appropriate.
  // E.g. here we do the CSV splitting of category descriptions.
  var types : [ String ] {
    description?
      .split(separator: ",")
      .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    ?? []
  }
}

struct CategoryInfo: View {
  
  let category : NorthwindCategory
  
  var body: some View {
    VStack {
      Text(verbatim: category.categoryName ?? "")
        .font(.title3)
        .padding(.top)
        .padding(.horizontal)
      
      if let info = category.description, !info.isEmpty {
        Text(category.types, format: .list(type: .and))
          .font(.body)
          .padding(.horizontal)
      }
      
      if let picture = category.picture, !picture.isEmpty {
        Image(picture: picture)
      }
    }
    .textSelection(.enabled)
    .clipShape(RoundedRectangle(cornerRadius: 8.0))
    .overlay(
      RoundedRectangle(cornerRadius: 8.0)
        .strokeBorder(Color.accentColor)
    )
    .padding()
  }
}
