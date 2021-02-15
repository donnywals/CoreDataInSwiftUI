import Combine
import CoreData

/// The `EditAlbumViewModel` encapsulates an editable Album and all logic related to editing (or creating) an album.
/// This ViewModel has an `album` property that represents the album we're working on, and an `artistName` property that's used to find and/or create an `Artist` object from the store.
/// We'll create a child context in this ViewModel to encapsulate the changes we're making to the album
class EditAlbumViewModel: ObservableObject {
  @Published var album: Album
  @Published var artistName: String
  
  let context: NSManagedObjectContext
  
  init(storageProvider: StorageProvider, album: Album? = nil) {
    self.context = storageProvider.childViewContext()
    
    if let objectID = album?.objectID,
       let albumCopy = try? self.context.existingObject(with: objectID) as? Album {
      self.album = albumCopy
      self.artistName = albumCopy.artist.name
    } else {
      self.album = Album(context: self.context)
      self.artistName = ""
    }
  }
  
  func persist() throws {
    let artist = Artist.findOrInsert(using: artistName, in: context)
    album.artist = artist

    try context.save()
    try context.parent?.save()
  }
}
