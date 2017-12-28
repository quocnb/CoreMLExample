//
//  ImageViewController+HandlerFace.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit
import Vision

extension ImageViewController {
    func handleFace(request: VNRequest, error: Error?, isLandmarkDetect: Bool = true) {
        guard let results = request.results as? [VNFaceObservation] else {
            return
        }
        DispatchQueue.main.async {
            self.handlerFaces(faces: results, isLandmarkDetect: isLandmarkDetect)
        }
    }

    func handleScene(request: VNRequest, error: Error?) {
        guard let sceneClassifier = request.results?.first as? VNClassificationObservation else {
            return
        }
        DispatchQueue.main.async {
            let scene = SceneType(classification: sceneClassifier.identifier)
            self.annotationView.classification = scene
            print("Scene: '\(sceneClassifier.identifier) \(sceneClassifier.confidence)%")
        }
    }

    private func handlerFaces(faces: [VNFaceObservation], isLandmarkDetect: Bool = true) {
        let viewSize = imageView.bounds.size
        let imageSize = image.size

        let widthRatio = viewSize.width / imageSize.width
        let heightRatio = viewSize.height / imageSize.height
        let scaledRatio = min(widthRatio, heightRatio)
        let scaleTransform = CGAffineTransform(scaleX: scaledRatio,
                                               y: scaledRatio)
        let scaledImageSize = imageSize.applying(scaleTransform)
        let imageX = (viewSize.width - scaledImageSize.width) / 2
        let imageY = (viewSize.height - scaledImageSize.height) / 2
        let imageLocationTransform = CGAffineTransform(
            translationX: imageX, y: imageY)
        let uiTransform = CGAffineTransform(scaleX: 1, y: -1)
            .translatedBy(x: 0, y: -imageSize.height)

        let faceDimensions = faces.flatMap { (face) -> FaceDimensions in
            let facebox = face.boundingBox.scaled(size: imageSize)
                .applying(uiTransform)
                .applying(scaleTransform)
                .applying(imageLocationTransform)
            let leftEyes = compute(feature: face.landmarks?.leftEye, faceBox: facebox)
            let rightEyes = compute(feature: face.landmarks?.rightEye, faceBox: facebox)
            return FaceDimensions(boundRect: facebox, leftEye: leftEyes, rightEye: rightEyes)
        }
        self.annotationView.faces = faceDimensions
    }

    private func compute(feature: VNFaceLandmarkRegion2D?,faceBox: CGRect) -> [CGPoint]? {
        guard let feature = feature else {
            return nil
        }
        var drawPoints: [CGPoint] = []
        for point in feature.normalizedPoints {
            // 1
            let cgPoint = CGPoint(x: CGFloat(point.x),
                                  y: CGFloat(1 - point.y))
            let scale = CGAffineTransform(scaleX: faceBox.width,
                                          // 2
                // 3
                y: faceBox.height)
            let translation = CGAffineTransform(
                translationX: faceBox.origin.x,
                y: faceBox.origin.y)
            let adjustedPoint =
                cgPoint.applying(scale).applying(translation)
            drawPoints.append(adjustedPoint)
        }
        return drawPoints
    }
}
