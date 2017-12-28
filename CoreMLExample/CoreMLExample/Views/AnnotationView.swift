//
//  AnnotationView.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

class AnnotationView: UIView {
    let hat = #imageLiteral(resourceName: "hat")
    let glasses = #imageLiteral(resourceName: "glasses")
    
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
            self.drawGlasses(left: faceDimension.leftEye, right: faceDimension.rightEye)
            self.isHidden = false
        }
    }

    private func drawBound(faceRect: CGRect) {
        let path = UIBezierPath(rect: faceRect)
        self.color.setStroke()
        path.stroke()
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }

    private func drawHat(faceRect: CGRect) {
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
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }

    private func drawGlasses(left: [CGPoint]?, right: [CGPoint]?) {
        guard let left = left, let right = right else {
            return
        }
        let total = left + right
        let minX = total.reduce(CGFloat.infinity) { min($0, $1.x) }
        let minY = total.reduce(CGFloat.infinity) { min($0, $1.y) }
        let maxX = total.reduce(0) { max($0, $1.x) }
        let maxY = total.reduce(0) { max($0, $1.y) }
        let width = max(maxX - minX, 16.0)
        let x = (maxX - minX) / 2.0 + minX - width / 2.0
        let height = max(maxY - minY, 8.0)
        let y = (maxY - minY) / 2.0 + minY - height / 2.0
        let eyesRect = CGRect(x: x, y: y,
                              width: width, height: height)
        glasses.draw(in: eyesRect)
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }

}
