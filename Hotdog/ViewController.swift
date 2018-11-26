//
//  ViewController.swift
//  Hotdog
//
//  Created by Spark Da Capo on 11/22/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet var photoDisplayImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func detect(with image: CIImage) {
        // try? will create an optional value containing resources.
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Fail to create model")}
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoDisplayImageView.image = pickedImage
            
            guard let ciimage = CIImage(image: pickedImage) else {
                fatalError("Could not convert to CIImage")
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
}

