import SwiftUI

/// The `AlbumsOverview` uses an `@FetchRequest` to show a list of `Album` objects.
/// It also presents a sheet to add new albums.
/// Eventually the `AlbumsOverview` will need to dynamically update the `@FetchRequest` in its `init`.
struct AlbumsOverview: View {
  let storageProvider: StorageProvider
  @State var presentedSheet: Sheet?
  @State var searchTerm = ""
  @State var groupType = Grouping.artist
  @SectionedFetchRequest(fetchRequest: Album.sortedByArtistAndRelease,
                         sectionIdentifier: \Album.artist.name) var albums
  var groupButtonLabel: String { groupType == .genre ? "Artist" : "Genre" }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(albums) { section in
          Section(header: Text("\(section.id)")) {
            ForEach(section) { album in
              NavigationLink(destination: AlbumDetailView(storageProvider: storageProvider, album: album)) {
                AlbumCell(album: album)
              }
            }
          }
        }
      }
      // modifiers for search
      .navigationBarItems(leading: Button("Group by \(groupButtonLabel)") {
        groupType = groupType == .genre ? .artist : .genre
      }, trailing: Button("Add new") {
        presentedSheet = .addAlbum
      })
      .onChange(of: groupType) { newGroupType in
        if newGroupType == .artist {
          albums.sectionIdentifier = \Album.artist.name
          albums.sortDescriptors = [
            SortDescriptor(\Album.artist.name, order: .forward),
            SortDescriptor(\Album.releaseDate, order: .forward)
          ]
        } else {
          albums.sectionIdentifier = \Album.genre
          albums.sortDescriptors = [
            SortDescriptor(\Album.genre, order: .forward),
            SortDescriptor(\Album.releaseDate, order: .forward)
          ]
        }
      }
      .navigationBarTitle("My Albums")
      .sheet(item: $presentedSheet) { item in
        switch item {
        case .addAlbum:
          CreateOrUpdateView(viewModel: EditAlbumViewModel(storageProvider: storageProvider),
                        dismiss: { presentedSheet = nil })
        }
      }
      .listStyle(PlainListStyle())
    }
  }
}

extension AlbumsOverview {
  enum Sheet: Identifiable {
    case addAlbum
    
    var id: Int {
      self.hashValue
    }
  }
        
  enum Grouping {
    case artist, genre
  }
}
