import SwiftUI
import CoreData

/// Similar to the `EditAlbumView` except it edits a single artist entry (and isn't used to create new albums)
struct EditArtistView: View {
  var dismiss: () -> Void
  
  @ObservedObject var viewModel: EditArtistViewModel
  
  @State var isErrorPresented = false
  
  init(viewModel: EditArtistViewModel, dismiss: @escaping () -> Void) {
    self.dismiss = dismiss
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Artist info"), content: {
          TextField("Artist name", text: $viewModel.artist.name)
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
      .navigationBarTitle("Edit Artist")
      .alert(isPresented: $isErrorPresented, content: {
        Alert(title: Text("Something went wrong"),
              message: Text("Ensure that all fields are filled"),
              dismissButton: .default(Text("Ok")))
      })
    }
  }
}
