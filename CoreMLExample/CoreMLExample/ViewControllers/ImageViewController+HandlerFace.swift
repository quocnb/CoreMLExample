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
    func handleFace(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNFaceObservation] else {
            return
        }
        DispatchQueue.main.async {
            self.handlerFaces(faces: results)
        }
    }

    private func handlerFaces(faces: [VNFaceObservation]) {
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
            return FaceDimensions(boundRect: facebox)
        }
        self.annotationView.faces = faceDimensions
    }
}
