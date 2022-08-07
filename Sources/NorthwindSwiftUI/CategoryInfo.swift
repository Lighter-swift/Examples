import Foundation
import SwiftUI
import Northwind

struct CategoryInfo: View {
  
  let category : NorthwindCategory
  
  var body: some View {
    HStack(alignment: .top) {
      if let picture = category.picture, !picture.isEmpty {
        Image(picture: picture)
      }
      
      VStack {
        Text(verbatim: category.categoryName ?? "")
          .font(.title3)
          .padding(.top)
          .padding(.horizontal)
        
        if let info = category.description, !info.isEmpty {
          Text(info)
            .font(.body)
            .padding(.horizontal)
        }
      }
    }
    .textSelection(.enabled)
    .clipShape(RoundedRectangle(cornerRadius: 8.0))
    .overlay(
      RoundedRectangle(cornerRadius: 8.0)
        .strokeBorder(Color.gray)
    )
    .padding()
  }
}
