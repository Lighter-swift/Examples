import SwiftUI
import Northwind
import Lighter

/// Global application state. A good place to setup the database object.
@main
struct NorthwindSwiftUIApp: App {
  
  let database : Northwind

  init() {
    // This is the URL where the database embedded in the Northwind package is
    // located.
    let resourceURL = Northwind.module.connectionHandler.url

    let fm = FileManager.default
    guard let url =
      fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
      .appendingPathComponent("Northwind.sqlite3") else
    {
      database = .module
      return
    }
    
    // Can we write to the destination URL already?
    if fm.isWritableFile(atPath: url.path) {
      print("Using existing DB at:", url.path)
      database = Northwind(url: url)
      return
    }
   
    // We don't have the editable DB yet, copy it.
    do {
      try fm.copyItem(at: resourceURL, to: url)
      database = Northwind(url: url)
      print("Bootstrapped editable DB at:", url.path)
    }
    catch {
      print("ERROR: failed to copy resource database:", resourceURL.path)
      database = .module
    }
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.database, database)
    }
  }
}

extension EnvironmentValues {
  
  private struct DatabaseKey: EnvironmentKey {
    static let defaultValue = Northwind.module!
  }
  
  /// Provide the Database object to the Views using the environment
  var database : Northwind {
    set { self[DatabaseKey.self] = newValue }
    get { self[DatabaseKey.self] }
  }
}

/// This is a simple formatter that can take optional Strings, turn them into
/// empty ones, and the reverse.
final class EmptyStringIsNullFormatter: Formatter {
  
  override func string(for value: Any?) -> String? {
    (value as? String) ?? ""
  }
  
  override func getObjectValue(
    _ value: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
    for string: String,
    errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool
  {
    value?.pointee = string.isEmpty ? nil : string as NSString
    return true
  }
}

extension Formatter {
  static let emptyIsNull = EmptyStringIsNullFormatter()
}
