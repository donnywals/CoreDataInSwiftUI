import CoreData
import UIKit

class Album: NSManagedObject, Identifiable {
  @NSManaged var albumCoverPath: String?
  @NSManaged var title: String
  @NSManaged var genre: String
  @NSManaged var releaseDate: Date
  @NSManaged var artist: Artist
  
  /// Convenience to load a `UIImage` from a path.
  var albumCover: UIImage? {
    guard let path = albumCoverPath else {
      return nil
    }

    let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).first!
    let url = documentsDirectory.appendingPathComponent(path)
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }

    return UIImage(data: data)
  }
  
  /// Stores an image in the documents directory and assigns `albumCoverPath`
  /// - Parameter image: The `UIImage` to store and assign.
  func setAlbumCover(_ image: UIImage) {
    guard let jpeg = image.jpegData(compressionQuality: 1) else {
      return
    }
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).first!
    
    if let oldFile = albumCoverPath {
      let oldPath = documentsDirectory.appendingPathComponent(oldFile).path
      if FileManager.default.fileExists(atPath: oldPath) {
        try? FileManager.default.removeItem(atPath: oldPath)
      }
    }
    
    let path = "\(UUID().uuidString).jpeg"
    
    let url = documentsDirectory.appendingPathComponent(path)
    do {
      try jpeg.write(to: url)
      albumCoverPath = path
    } catch {
      albumCoverPath = nil
      print(error)
    }
  }
  
  /// Allows us to set default values for properties in our model as soon as we insert a managed object into a context
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    
    releaseDate = Date()
  }
}

//MARK: fetch requests
extension Album {
  static func fetchRequest() -> NSFetchRequest<Album> {
    return NSFetchRequest(entityName: "Album")
  }

  static var sortedByArtistAndRelease: NSFetchRequest<Album> {
    let request: NSFetchRequest<Album> = fetchRequest()

    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \Album.artist.name, ascending: true),
      NSSortDescriptor(keyPath: \Album.releaseDate, ascending: true)
    ]
    
    return request
  }
}
