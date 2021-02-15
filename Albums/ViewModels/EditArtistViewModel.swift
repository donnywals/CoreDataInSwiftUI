import Combine
import CoreData

/// The `EditArtistViewModel` is similar to the `EditAlbumViewModel` but it's used  to edit an artist.
/// You'll implement logic to persist an artist and refresh its related objects to ensure the `AlbumsOverview` updates correctly
class EditArtistViewModel: ObservableObject {
  @Published var artist: Artist
  let context: NSManagedObjectContext
  
  init(storageProvider: StorageProvider, artist: Artist) {
    self.context = storageProvider.childViewContext()
    self.artist = try! self.context.existingObject(with: artist.objectID) as! Artist
  }
  
  func persist() throws {
    try context.save()
    try context.parent?.save()

    for album in artist.albums {
      if let sourceAlbum = try? context.parent?.existingObject(with: album.objectID) {
        context.parent?.refresh(sourceAlbum, mergeChanges: true)
      }
    }
  }
}
