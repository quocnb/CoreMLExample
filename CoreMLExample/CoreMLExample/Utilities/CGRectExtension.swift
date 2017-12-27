//
//  CGRectExtension.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/27/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import UIKit

extension CGRect {
    func scaled(size: CGSize) -> CGRect {
        return CGRect(x: minX * size.width,
                      y: minY * size.height,
                      width: width * size.width,
                      height: height * size.height)
    }
}
