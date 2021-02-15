import SwiftUI
import CoreData

/// This view contains the edit logic for albums, it's used to create new albums as well as existing albums.
/// It also uses the `PhotoPicker` component to present a `PHPickerViewController` to allow users to select a photo for their albums
struct CreateOrUpdateView: View {
  var dismiss: () -> Void
  
  @ObservedObject var viewModel: EditAlbumViewModel
  
  @State var isErrorPresented = false
  @State var isPresentingPicker = false
  
  @State var selectedPhoto: UIImage?
  
  init(viewModel: EditAlbumViewModel, dismiss: @escaping () -> Void) {
    self.viewModel = viewModel
    self.dismiss = dismiss
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Album info"), content: {
          TextField("Artist name", text: $viewModel.artistName)
          TextField("Album title", text: $viewModel.album.title)
          TextField("Genre", text: $viewModel.album.genre)
          DatePicker(selection: $viewModel.album.releaseDate, in: ...Date(), displayedComponents: .date) {
            Text("Release date")
          }
        })
        
        Section(header: Text("Album Cover"), content: {
          HStack {
            if let photo = viewModel.album.albumCover {
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
            
            Button("Select photo") {
              isPresentingPicker = true
            }
          }
        })
      }
      .navigationBarItems(
        leading: Button("Cancel") {
          dismiss()
        }, trailing: Button("Save") {
          do {
            try viewModel.persist()
            dismiss()
          } catch {
            print("Something went wrong \(error)")
            isErrorPresented = true
          }
        })
      .onChange(of: selectedPhoto) { photo in
        if let image = photo {
          viewModel.album.setAlbumCover(image)
        } else {
          viewModel.album.albumCoverPath = nil
        }
      }
      .navigationBarTitle("Add New Album")
      .sheet(isPresented: $isPresentingPicker, content: {
        PhotoPicker(selectedPhoto: $selectedPhoto, dismiss: { self.isPresentingPicker = false })
      })
      .alert(isPresented: $isErrorPresented, content: {
        Alert(title: Text("Something went wrong"),
              message: Text("Ensure that all fields are filled"),
              dismissButton: .default(Text("Ok")))
      })
    }
  }
}
