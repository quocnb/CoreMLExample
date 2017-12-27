//
//  AnnotationView.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

class AnnotationView: UIView {

    @IBInspectable
    var color: UIColor = .orange {
        didSet {
            setNeedsDisplay()
        }
    }

    var faces: [FaceDimensions] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        faces.forEach { (faceDimension) in
            self.drawBound(faceRect: faceDimension.boundRect)
            self.drawHat(faceRect: faceDimension.boundRect)
        }
    }

    private func drawBound(faceRect: CGRect) {
        let path = UIBezierPath(rect: faceRect)
        self.color.setStroke()
        path.stroke()
    }

    private func drawHat(faceRect: CGRect) {
        let hat = #imageLiteral(resourceName: "hat")
        let hatSize = hat.size
        let headSize = faceRect.size
        let newHatWidth = 1.5 * headSize.width
        let hatRatio = newHatWidth / hatSize.width

        let scaleTransform = CGAffineTransform(scaleX: hatRatio, y: hatRatio)
        let adjustHatsize = hatSize.applying(scaleTransform)

        let hatRect = CGRect(x: faceRect.midX - (adjustHatsize.width / 2.0),
                             y: faceRect.minY - adjustHatsize.height,
                             width: adjustHatsize.width,
                             height: adjustHatsize.height)
        hat.draw(in: hatRect)
    }

}
