//
//  FaceDimensions.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

struct FaceDimensions {
    var boundRect: CGRect
    var leftEye: [CGPoint]?
    var rightEye: [CGPoint]?
    
    init(boundRect: CGRect, leftEye: [CGPoint]?, rightEye: [CGPoint]?) {
        self.boundRect = boundRect
        self.leftEye = leftEye
        self.rightEye = rightEye
    }
}
