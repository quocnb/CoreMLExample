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
        drawFacesBounds()
    }

    private func drawFacesBounds() {
        self.faces.forEach { (face) in
            let path = UIBezierPath(rect: face.boundRect)
            self.color.setStroke()
            path.stroke()
        }
    }

}
