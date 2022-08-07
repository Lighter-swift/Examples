import Combine
import Lighter

/**
 * A datasource is an ObservableObject (for SwiftUI purposes) that wraps a
 * specific table.
 *
 * It can be used like this in a SwiftUI View:
 * ```swift
 * @StateObject private var products = DataSource(database.products)
 * ```
 */
@MainActor
final class DataSource<DB: SQLDatabaseAsyncFetchOperations, T: SQLRecord>
            : ObservableObject
{
  
  let table : SQLRecordFetchOperations<DB, T>
  
  @Published var items = [ T ]()
  
  init(_ table: SQLRecordFetchOperations<DB, T>) {
    self.table = table
  }
  
  func fetch() async throws {
    items = try await table.fetch()
  }
}
