//
//  UIScreen+Resolution.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/18/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit
import CoreGraphics

// All possible resolutions of iOS devices, measured in pixels.
let UIScreenResolution320x480   = "UIScreenResolution320×480"   // iPhone 1st Gen, 3G, 3GS
let UIScreenResolution640x960   = "UIScreenResolution640×960"   // iPhone 4, 4S
let UIScreenResolution640x1136  = "UIScreenResolution640×1136"  // iPhone 5, 5C, 5S, iPhone SE, iPod Touch 5g
let UIScreenResolution750x1334  = "UIScreenResolution750×1334"  // iPhone 6, iPhone 6s, iPhone 7, iPhone 8
let UIScreenResolution1242x2208 = "UIScreenResolution1242×2208" // iPhone 6 Plus, iPhone 6s Plus, iPhone 7 Plus, iPhone 8 Plus
let UIScreenResolution1125x2436 = "UIScreenResolution1125×2436" // iPhone X
let UIScreenResolution1536x2048 = "UIScreenResolution1536×2048" // iPad 3, iPad 4, iPad Air, iPad Air 2, 9.7-inch iPad Pro, iPad Mini, iPad Mini 2, iPad Mini 3, iPad Mini 4
let UIScreenResolution1668x2224 = "UIScreenResolution1668×2224" // iPad Pro 10.5″
let UIScreenResolution2048x2732 = "UIScreenResolution2048×2732" // iPad Pro 12.9″
let UIScreenResolution272x340   = "UIScreenResolution272×340"   //  Watch 38mm
let UIScreenResolution312x390   = "UIScreenResolution312×390"   //  Watch 42mm
let UIScreenResolutionUndefined = "UIScreenResolutionUndefined" // This is just a last resort, you should always get a valid resolution instead.

extension UIScreen {
    
    static var mainBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    static var mainScale: CGFloat {
        return UIScreen.main.scale
    }
    
    static var scaledWidth: Int {
        return Int(mainScale * mainBounds.size.width)
    }
    
    static var scaledHeight: Int {
        return Int(mainScale * mainBounds.size.height)
    }
    
    static var minLength: Int {
        return min(scaledWidth, scaledHeight)
    }
    
    static var maxLength: Int {
        return max(scaledWidth, scaledHeight)
    }
    
    static var resolution: String {
        switch (minLength, maxLength) {
        case (320, 480):
            return UIScreenResolution320x480
        case (640, 960):
            return UIScreenResolution640x960
        case (640, 1136):
            return UIScreenResolution640x1136
        case (750, 1334):
            return UIScreenResolution750x1334
        case (1242, 2208):
            return UIScreenResolution1242x2208
        case (1125, 2436):
            return UIScreenResolution1125x2436
        case (1536, 2048):
            return UIScreenResolution1536x2048
        case (1668, 2224):
            return UIScreenResolution1668x2224
        case (2048, 2732):
            return UIScreenResolution2048x2732
        case (272, 340):
            return UIScreenResolution272x340
        case (312, 390):
            return UIScreenResolution312x390
        default:
            return UIScreenResolutionUndefined
        }
    }
}
