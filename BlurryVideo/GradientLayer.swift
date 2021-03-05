//
//  GradientLayer.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/15/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

//import UIKit
//import QuartzCore
//
//class GradientLayer: CAGradientLayer {
//    
//    enum Direction {
//        case horizontal
//        case vertical
//    }
//    
//    var direction: Direction = .vertical {
//        didSet {
//            CALayer.performWithoutAnimation { 
//                self.applyGradient()
//            }
//        }
//    }
//    
//    // left / top color
//    var firstColor: UIColor? {
//        didSet {
//            CALayer.performWithoutAnimation {
//                self.applyGradient()
//            }
//        }
//    }
//    
//    // right / bottom color
//    var secondColor: UIColor? {
//        didSet {
//            CALayer.performWithoutAnimation {
//                self.applyGradient()
//            }
//        }
//    }
//    
//    private func applyGradient() {
//        let firstColor: UIColor = self.firstColor ?? UIColor.clear
//        let secondColor: UIColor = self.secondColor ?? UIColor.clear
//        colors = [firstColor.cgColor, secondColor.cgColor]
//        switch direction {
//        case .horizontal:
//            startPoint =  CGPoint(x: 0.0, y: 0.5)
//            endPoint = CGPoint(x: 1.0, y: 0.5)
//            break
//        case .vertical:
//            startPoint =  CGPoint(x: 0.5, y: 0.0)
//            endPoint = CGPoint(x: 0.5, y: 1.0)
//            break
//        }
//    }
//}
