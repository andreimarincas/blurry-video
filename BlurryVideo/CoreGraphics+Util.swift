//
//  CoreGraphics+Util.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/18/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    init(center: CGPoint, size: CGSize) {
        origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.size = size
    }
    
    var center: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    var frameCenter: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
    
    var boundsOnly: CGRect {
        return CGRect(origin: .zero, size: size)
    }
    
    var topLeft: CGPoint {
        return origin
    }
    
    var topRight: CGPoint {
        return CGPoint(x: origin.x + size.width, y: origin.y)
    }
    
    var bottomLeft: CGPoint {
        return CGPoint(x: origin.x, y: origin.y + size.height)
    }
    
    var bottomRight: CGPoint {
        return CGPoint(x: origin.x + size.width, y: origin.y + size.height)
    }
    
    var leftMiddle: CGPoint {
        return CGPoint(x: origin.x, y: origin.y + size.height / 2)
    }
    
    func insetBy(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
        let origin = CGPoint(x: self.origin.x + left, y: self.origin.y + top)
        let size = CGSize(width: self.width - left + right, height: self.height - top + bottom)
        return CGRect(origin: origin, size: size)
    }
    
    // Give `aspect` as width/height ratio.
    func sizeThatFitsInside(withAspect aspect: CGFloat) -> CGSize {
        let myAspect = width / height
        var fitSize: CGSize = .zero
        if aspect >= myAspect {
            fitSize.width = width
            fitSize.height = (1.0 / aspect) * width
        } else {
            fitSize.width = aspect * height
            fitSize.height = height
        }
        return fitSize
    }
}

extension CGPoint {
    
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
