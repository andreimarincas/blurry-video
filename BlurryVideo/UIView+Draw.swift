//
//  UIView+Draw.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension UIView {
    
    func drawTopLine(width lineWidth: CGFloat, color strokeColor: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(strokeColor.cgColor)
        let topLeft = CGPoint(x: 0, y: lineWidth)
        let topRight = CGPoint(x: frame.size.width, y: lineWidth)
        context.strokeLineSegments(between: [topLeft, topRight])
        context.restoreGState()
    }
    
    func drawBottomLine(width lineWidth: CGFloat, color strokeColor: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(strokeColor.cgColor)
        let bottomLeft = CGPoint(x: 0, y: frame.size.height - lineWidth)
        let bottomRight = CGPoint(x: frame.size.width, y: frame.size.height - lineWidth)
        context.strokeLineSegments(between: [bottomLeft, bottomRight])
        context.restoreGState()
    }
}
