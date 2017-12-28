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
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        self.image = self.image.bestScale(in: self.imageView.bounds.size)
        self.imageView.image = self.image
        self.annotationView.isHidden = true
        detectImage()
    }

    func detectImage() {
        guard let cgImage = image.cgImage else {
            return
        }
        var requests: [VNRequest] = [faceDetectRequest()]
        if let sceneRequest = sceneDetectRequest() {
            requests.append(sceneRequest)
        }

        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        let handleRequest = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handleRequest.perform(requests)
            } catch {
                print("Error handling vision request \(error)")
            }
        }
    }

    func sceneDetectRequest() -> VNRequest? {
        let ggNetPlace = GoogLeNetPlaces()
        do {
            let model = try VNCoreMLModel(for: ggNetPlace.model)
            let request = VNCoreMLRequest(model: model, completionHandler: handleScene)
            return request
        } catch {
            return nil
        }
    }

    func faceDetectRequest(isLandmarkDetect: Bool = true) -> VNRequest {
        if isLandmarkDetect {
            return VNDetectFaceLandmarksRequest(completionHandler: { (request, error) in
                self.handleFace(request: request, error: error, isLandmarkDetect: true)
            })
        } else {
            return VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
                self.handleFace(request: request, error: error, isLandmarkDetect: false)
            })
        }
    }

}
