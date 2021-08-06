//
//  ImagePicker.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 1.08.2021.
//

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent : ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
        
    }
    
    @Binding var image : UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}



func loadImage(fileName: UUID) -> Image? {
    let path = FileManager.default.getDocumentsDirectory.appendingPathComponent(fileName.uuidString + ".jpg").path
    if let uiImage = UIImage(contentsOfFile: path) {
        return Image(uiImage: uiImage)
    }
    return nil
}
