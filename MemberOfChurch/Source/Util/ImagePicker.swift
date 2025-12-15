//
//  ImagePicker.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    enum Source { case camera }
    
    let source: Source
    var onFinish: (Data?) -> Void
    
    func makeCoordinator() -> Coordinator { Coordinator(onFinish: onFinish) }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onFinish: (Data?) -> Void
        init(onFinish: @escaping (Data?) -> Void) { self.onFinish = onFinish }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let img = (info[.originalImage] as? UIImage)
            let data = img?.jpegData(compressionQuality: 0.9)
            onFinish(data)
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onFinish(nil)
            picker.dismiss(animated: true)
        }
    }
}
