////
////  Aspect.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/18/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//
//struct AspectRatio {
//    
//    var width: Int
//    var height: Int
//    
//    init() {
//        width = 0
//        height = 0
//    }
//    
//    init(_ width: Int, _ height: Int) {
//        self.width = width
//        self.height = height
//    }
//}
//
//enum Aspect: Int {
//    
//    case fullscreen = 0
//    case fullscreenPortrait
//    case widescreen
//    case widescreenPortrait
//    case custom(Int)
//    
//    var ratio: AspectRatio {
//        switch self {
//        case .fullscreen:
//            return AspectRatio(4, 3)
//        case .fullscreenPortrait:
//            return AspectRatio(3, 4)
//        case .widescreen:
//            return AspectRatio(16, 9)
//        case .widescreenPortrait:
//            return AspectRatio(9, 16)
//        case .custom:
//            return AspectRatio()
//        }
//    }
//
//    // width / height
//    var value: Float {
//        if self != .custom {
//            return Float(ratio.width) / Float(ratio.height)
//        }
//        return 0
//    }
//}
