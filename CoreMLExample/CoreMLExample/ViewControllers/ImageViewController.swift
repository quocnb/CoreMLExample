//
//  AppDelegate.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//


import UIKit
import Vision

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var annotationView: AnnotationView!
    
    var image: UIImage! {
        didSet {
            imageView?.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        imageView.image = image
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFaceDetect(image: self.image)
    }

    func setupFaceDetect(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        let faceRequest = VNDetectFaceRectanglesRequest(completionHandler: handleFace)
        let handleRequest = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handleRequest.perform([faceRequest])
            } catch {
                print("Error handling vision request \(error)")
            }
        }
    }

}