//
//  UIImageExtension.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/28/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

extension UIImage {
    func bestScale(in size: CGSize) -> UIImage {
        let imageWidth = self.size.width, imageHeight = self.size.height
        let scaleRatio = min(size.width/imageWidth, size.height/imageHeight)
        guard scaleRatio < 1 else {
            return self
        }
        let newWidth = imageWidth * scaleRatio
        let newHeight = imageHeight * scaleRatio
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, true, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
