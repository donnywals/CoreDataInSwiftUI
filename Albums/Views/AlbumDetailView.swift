import SwiftUI

/// Detail page for albums, can present an editing view for a given album.
struct AlbumDetailView: View {
  static let albumDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }()
  
  let storageProvider: StorageProvider
  @ObservedObject var album: Album

  @State var isEditingAlbum = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if let cover = album.albumCover {
        Image(uiImage: cover)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 160, height: 160)
          .cornerRadius(16)
          .clipped()
      }
      
      
      NavigationLink(destination: ArtistDetailView(artist: album.artist,
                                                   storageProvider: storageProvider)) {
        Text("\(album.artist.name)")
          .font(.title2)
          .bold()
      }

      Text(album.title)
        .bold()
        .padding([.bottom], 16)
      Text("Genre: ").bold() + Text(album.genre)
      Text("Released: ").bold() + Text("\(album.releaseDate, formatter: Self.albumDateFormat)")
    }
    .padding(16)
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .navigationBarItems(trailing: Button("Edit") {
      isEditingAlbum = true
    })
    .navigationBarTitle(Text(album.title), displayMode: .inline)
    .sheet(isPresented: $isEditingAlbum) {
      CreateOrUpdateView(viewModel: EditAlbumViewModel(storageProvider: storageProvider,
                                                  album: album),
                    dismiss: { self.isEditingAlbum = false })
    }
  }
}
