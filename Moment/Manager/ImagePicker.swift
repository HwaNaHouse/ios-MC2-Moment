//
//  ImagePicker.swift
//  Moment
//
//  Created by 김민재 on 2022/06/10.
//

import SwiftUI
import PhotosUI

/*
 * ImagePicker
 */

struct ImagePicker : UIViewControllerRepresentable{
    
    
    @Binding var images : [UIImage]
    @Binding var picker : Bool
    
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent1 : self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        // UI appearance setting
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor(#colorLiteral(red: 0.4582511783, green: 0.4393250346, blue: 0.9288574457, alpha: 1))
        UINavigationBar.appearance().backgroundColor = .white
        UIView.appearance().tintColor = UIColor(#colorLiteral(red: 0.4582511783, green: 0.4393250346, blue: 0.9288574457, alpha: 1))
        
        // PHPicker config
        var config = PHPickerConfiguration()
        config.preferredAssetRepresentationMode = .compatible
        config.filter = .images
        config.selectionLimit = 0
        
        // PHPicker
        let picker = PHPickerViewController(configuration:  config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator : NSObject, PHPickerViewControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1 : ImagePicker) {
            parent = parent1
        }
        
        // Source : https://gist.github.com/Zedd0202/c24ff34ee6eb313f6ea81d83e25a4631#file-phpickerviewcontrollerdelegate-swift
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) {
                        (image, err) in
                        guard let image1 = image else {
                            return
                        }
                        self.parent.images.append(image1 as! UIImage)
                        
                    }
                } else{
                    print("cannot be loaded")
                }
            }
            parent.picker.toggle()
        }
    }
}
