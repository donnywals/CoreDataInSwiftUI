import SwiftUI

@main
struct AlbumsApp: App {
  @State var storageProvider: StorageProvider
  
  init() {
    let storageProvider = StorageProvider()
    self._storageProvider = State(wrappedValue: storageProvider)
  }
  
  var body: some Scene {
    WindowGroup {
      AlbumsOverview(storageProvider: storageProvider)
        .environment(\.managedObjectContext, storageProvider.viewContext)
    }
  }
}
