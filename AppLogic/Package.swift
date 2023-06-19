// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "AppLogic",
  
  // This is required because the Northwind package has the same requirement.
  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .library(name: "WebDependencies", targets: [ "WebDependencies" ]),
    .library(name: "AppDependencies", targets: [ "AppDependencies" ])
  ],
  
  // The dependencies.
  dependencies: [
    .package(url: "https://github.com/Lighter-swift/Lighter.git",
             from: "1.0.24"),
    .package(url: "https://github.com/Lighter-swift/NorthwindSQLite.swift.git",
             from: "1.0.12"),
    
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "1.0.2"),
  
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  
  // Our own targets, those are linked by the Xcode project targets.
  targets: [
    .target(name: "WebDependencies", dependencies: [
      "MacroExpress",
      .product(name: "Northwind", package: "NorthwindSQLite.swift")
    ]),
    .target(name: "AppDependencies", dependencies: [
      .product(name: "Northwind", package: "NorthwindSQLite.swift")
    ])
  ]
)
