<h2>Lighter Examples AppLogic Helper
  <img src="https://zeezide.com/img/lighter/Lighter256.png"
       align="right" width="64" height="64" />
</h2>

This is a helper package until Xcode 14 project level package dependencies
properly run package plugins.

It is generally a good idea to manage Xcode package dependencies in such a
local package.

Since the APIs require macOS 10.15 / iOS 13, this platforms declaration is
usually needed in the [Package.swift](Package.swift):
```swift
  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
```

### Who

Lighter is brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.
