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
    @IBOutlet weak var itemIdentifierLabel: UILabel!
    
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
        let request = VNCoreMLRequest(model: model) { (completeRequest, error) in
            guard let results = completeRequest.results as? [VNClassificationObservation] else {
                fatalError("Fail to convert request results into VNClassificationObservation")
            }
            if let firstResult = results.first {
                let stringIdentifier = firstResult.identifier
                
                print(stringIdentifier)
                self.itemIdentifierLabel.text = "This item could be \(stringIdentifier)"
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }catch {
            print(error)
        }
        
        
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
            detect(with: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
}

