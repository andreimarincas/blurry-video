//
//  UIImage+Util.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension UIImage {
    
    func withAlpha(_ value: CGFloat) -> UIImage {
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(size: size, format: format)
            let newImage = renderer.image { context in
                draw(at: .zero, blendMode: .normal, alpha: value)
            }
            return newImage
        }
        // Fallback on earlier versions
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
