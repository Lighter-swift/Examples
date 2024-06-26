import SwiftUI
import Northwind
import Lighter
import SQLite3

/// Global application state. A good place to setup the database object.
@main
struct NorthwindApp: App {
  
  let database = (try? Northwind.bootstrap(
    copying: Northwind.module.connectionHandler.url
  )) ?? .module!
    
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.database, database)
      #if os(macOS)
        .frame(minWidth: 640, minHeight: 340)
      #endif
    }
  }
}


// MARK: - Environment Keys

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


// MARK: - Custom Formatters

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
  @MainActor
  static let emptyIsNull = EmptyStringIsNullFormatter()
}
