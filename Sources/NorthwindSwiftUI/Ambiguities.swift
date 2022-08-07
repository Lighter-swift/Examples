import Northwind

// Sometimes database types clash with other types, e.g. in SwiftUI.
// Such can be disambiguated in a file importing just the specific module.
// Note: This is an issue because `Northwind` the database type is the
//       same like `Northwind` the target name (import).

typealias NorthwindCategory = Category
