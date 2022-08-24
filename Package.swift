// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "LighterExamples",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .executable(name: "NorthwindWebAPI", targets: [ "NorthwindWebAPI" ])
  ],
  
  dependencies: [
    .package(url: "https://github.com/Lighter-swift/Lighter.git", from: "1.0.4"),
    .package(url: "https://github.com/Lighter-swift/NorthwindSQLite.swift.git",
             from: "1.0.8"),
             
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.9.0"),

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
