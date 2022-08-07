<h2>Lighter Examples
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

Examples for the Lighter SQLite environment, SwiftUI and server side.

Note: The examples requires Swift 5.7 / Xcode 14b for proper plugin support.

When embedding a package using Lighter (like
[NorthwindSQLite.swift](https://github.com/Lighter-swift/NorthwindSQLite.swift.git)),
[a local package](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages) 
seems to be required w/ the Xcode 14 beta.
Otherwise the Swift package plugins do not seem to run.
In the example project this is the "AppLogic" package.


### Examples

- [NorthwindWebAPI](Sources/NorthwindWebAPI/) (A server side Swift example
  exposing the DB as a JSON API endpoint, and providing a few pretty HTML pages
  showing data contained.)


### Dependencies

This example pulls in a lot of bigger dependencies. A real Lighter project can
actually work w/ no external dependencies at all.


### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

**Want to support my work**?
Buy an app:
[Past for iChat](https://apps.apple.com/us/app/past-for-ichat/id1554897185),
[SVG Shaper](https://apps.apple.com/us/app/svg-shaper-for-swiftui/id1566140414),
[Shrugs](https://shrugs.app/),
[HMScriptEditor](https://apps.apple.com/us/app/hmscripteditor/id1483239744).
You don't have to use it! 😀
