import SwiftUI

#if os(macOS)
  import class AppKit.NSImage
#else
  import class UIKit.UIImage
#endif

extension Image {
  
  /// Initialize a SwiftUI image from a bytearray, as stored in Northwind.
  init?(picture: [ UInt8 ]) {
    
    #if os(macOS)
      guard let image = NSImage(data: Data(picture)) else { return nil }
      self.init(nsImage: image)
    #else
      guard let image = UIImage(data: Data(picture)) else { return nil }
      self.init(uiImage: image)
    #endif
  }
  
}
