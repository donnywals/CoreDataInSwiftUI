import SwiftUI
import UIKit
import PhotosUI

/// Helper view to present a `PHPickerViewController`
struct PhotoPicker: UIViewControllerRepresentable {
  @Binding var selectedPhoto: UIImage?
  let dismiss: () -> Void
  
  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 1
    let vc = PHPickerViewController(configuration: configuration)
    vc.delegate = context.coordinator
    return vc
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    // no-op
  }
  
  func makeCoordinator() -> Delegate {
    return Delegate(pickerView: self)
  }
}

extension PhotoPicker {
  class Delegate: PHPickerViewControllerDelegate {
    private let pickerView: PhotoPicker
    
    init(pickerView: PhotoPicker) {
      self.pickerView = pickerView
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      for result in results where result.itemProvider.canLoadObject(ofClass: UIImage.self) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
          if let error = error {
            print(error)
            return
          }
          
          self?.pickerView.selectedPhoto = image as? UIImage
        }
      }
      
      pickerView.dismiss()
    }
  }
}
