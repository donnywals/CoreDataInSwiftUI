import CoreData

class Artist: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var albums: Set<Album>
  
  static func findOrInsert(using name: String, in context: NSManagedObjectContext) -> Artist {
    let request = NSFetchRequest<Artist>(entityName: "Artist")
    request.predicate = NSPredicate(format: "%K == %@",
                                    #keyPath(Artist.name),
                                    name)
    request.fetchLimit = 1

    if let result = try? context.fetch(request),
       let artist = result.first {

      return artist
    }

    let artist = Artist(context: context)
    artist.name = name

    return artist
  }
}
