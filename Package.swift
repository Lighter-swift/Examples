// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "LighterExamples",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .executable(name: "NorthwindWebAPI", targets: [ "NorthwindWebAPI" ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Lighter-swift/Lighter.git", from: "1.0.30"),
    .package(url: "https://github.com/Northwind-swift/NorthwindSQLite.swift.git",
             from: "1.0.14"),
             
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "1.0.2"),

    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  
  targets: [
    .executableTarget(
      name: "NorthwindWebAPI",
      dependencies: [
        .product(name: "Northwind", package: "NorthwindSQLite.swift"),
        "MacroExpress"
      ],
      exclude: [ "views", "README.md" ]
    )
  ]
)
