// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "LighterExamples",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [
    .executable(name: "NorthwindWebAPI", targets: [ "NorthwindWebAPI" ])
  ],
  
  dependencies: [
    .package(url: "git@github.com:55DB091A-8471-447B-8F50-5DFF4C1B14AC/Lighter.git",
             branch: "develop"),
    .package(url: "git@github.com:55DB091A-8471-447B-8F50-5DFF4C1B14AC/NorthwindSQLite.swift.git",
             branch: "develop"),
             
    .package(url: "https://github.com/Macro-swift/MacroExpress.git",
             from: "0.8.8"),

    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  
  targets: [
    .executableTarget(
      name: "NorthwindWebAPI",
      dependencies: [
        .product(name: "Northwind", package: "NorthwindSQLite.swift"),
        "MacroExpress"
      ],
      exclude: [ "views" ]
    )
  ]
)
