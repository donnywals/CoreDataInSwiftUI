import SwiftUI

/// Presents album info in a cell that's used in `AlbumsOverview`
struct AlbumCell: View {
  @ObservedObject var album: Album

  var body: some View {
    HStack {
      if let photo = album.albumCover {
        Image(uiImage: photo)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 85, height: 85)
          .cornerRadius(8)
          .clipped()
      } else {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.gray)
          .frame(width: 85, height: 85)
      }

      VStack(alignment: .leading, spacing: 8) {
        Text(album.artist.name)
          .bold()
        Text(album.title)
      }
    }
  }
}

