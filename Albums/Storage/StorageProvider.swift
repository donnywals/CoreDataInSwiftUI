import CoreData
import Foundation

/// Normally `NSPersistentContainer` looks for your model file in the app bundle. This is fine for apps, but if you add Core Data in a framework you'll want it to look for your model file in the framework target. Using a subclass will ensure that Core Data looks for a model file in the subclass' bundle.
class PersistentContainer: NSPersistentContainer {}

/// The main storage provider object in our app
class StorageProvider {
  let persistentContainer: PersistentContainer
  
  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  init() {
    persistentContainer = PersistentContainer(name: "Albums")
    
    persistentContainer.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }
  
  func childViewContext() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = persistentContainer.viewContext
    return context
  }
}
