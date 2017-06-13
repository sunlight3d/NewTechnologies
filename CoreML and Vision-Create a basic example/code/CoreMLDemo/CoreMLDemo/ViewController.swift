//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Nguyen Duc Hoang on 6/13/17.
//  Copyright © 2017 Nguyen Duc Hoang. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController{
    @IBOutlet  var lblState: UILabel?
    @IBOutlet  var imageView: UIImageView?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblState?.text = "Analizing your image..."
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("Cannot load ML Model")
        }
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let firstResult = results.first else {
                    fatalError("Cannot get result from VNCoreMLRequest")
            }
            DispatchQueue.main.async {
                [weak self] in
                self!.lblState?.text = "confidence = \(Int(firstResult.confidence * 100))%,\n identifier = \((firstResult.identifier))"
            }
            
        }
        guard let ciImage = CIImage(image: (imageView?.image)!) else {
            fatalError("Convert CIImage from UIImage failed")
        }
        let imageHandle = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try imageHandle.perform([request])
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
}

