<h2>Lighter Examples
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

Examples for the Lighter SQLite environment, SwiftUI and server side.

Note: The examples require Swift 5.7 / Xcode 14b for proper plugin support.

When embedding a package using Enlighter (like
[NorthwindSQLite.swift](https://github.com/Lighter-swift/NorthwindSQLite.swift.git)),
[a local package](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages) 
seems to be required w/ the Xcode 14 beta (3...5).
Otherwise the Swift package plugins do not seem to run.
In the example project this is the "AppLogic" package.
If Xcode gets stuck or doesn't run the plugin, a package update sometimes
help.


### Northwind Database

The Northwind database is a common database example that has been ported
to SQLite. 
Lighter provides a Swift version of that in the
[NorthwindSQLite.swift](https://github.com/Lighter-swift/NorthwindSQLite.swift)
repository.

> Note: The particular SQLite version of the Northwind database is quite 
> lacking. For example booleans are stored as TEXTs, many columns are
> inappropriately marked as `NULL`able.<br>
> That actually makes it a good example on how to deal with such databases in
> Lighter.

The Swift Northwind API: [Documentation](https://Lighter-swift.github.io/NorthwindSQLite.swift/documentation/northwind/).


### Examples

- [Northwind](https://Lighter-swift.github.io/NorthwindSQLite.swift/documentation/northwind/) Database:
    - [NorthwindWebAPI](Sources/NorthwindWebAPI/) (A server side Swift example
      exposing the DB as a JSON API endpoint, and providing a few pretty HTML
      pages showing data contained.)
    - [NorthwindSwiftUI](Sources/NorthwindSwiftUI/) (A SwiftUI example that lets
      one browse the Northwind database. Uses the Lighter API in combination with
      its async/await supports.)
- Custom database:
    - [Bodies](Sources/Bodies/) (A SwiftUI example which loads a list of solar
      bodies from the [web](https://api.le-systeme-solaire.net/en/) and keeps
      an offline-first, local cache in a SQL source based Lighter setup.)

### Dependencies

This example pulls in a lot of bigger dependencies. A real Lighter project can
actually work w/ no external dependencies at all.

### Screenshots

#### Northwind SwiftUI

<img width="1014" alt="Screenshot 2022-08-16 at 16 41 31" src="https://user-images.githubusercontent.com/7712892/184908144-22cf9a9a-7901-4815-9453-61d8602a093f.png">

#### Northwind Web API

<img width="890" alt="MacroSample-Product-List" src="https://user-images.githubusercontent.com/7712892/184907723-f76691b2-a0bf-4c04-b866-55599603afa4.png">
<img width="890" alt="Macro-Sample-Product-Detail" src="https://user-images.githubusercontent.com/7712892/184907762-cead2c35-1e80-49ce-a5c6-d3522d145411.png">

#### Solar Bodies

<img width="534" alt="Screenshot 2022-08-12 at 16 05 09" src="https://user-images.githubusercontent.com/7712892/184907841-f0aec194-1b60-42c7-a300-561f3349e5ef.png">



### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

**Want to support my work**?
Buy an app:
[Code for SQLite3](https://apps.apple.com/us/app/code-for-sqlite3/id1638111010),
[Past for iChat](https://apps.apple.com/us/app/past-for-ichat/id1554897185),
[SVG Shaper](https://apps.apple.com/us/app/svg-shaper-for-swiftui/id1566140414),
[Shrugs](https://shrugs.app/),
[HMScriptEditor](https://apps.apple.com/us/app/hmscripteditor/id1483239744).
You don't have to use it! 😀
