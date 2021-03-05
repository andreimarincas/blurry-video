//
//  NavigationController+Animations.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/26/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension NavigationController {
    
    func addShadowAnimation(toViewController viewController: UIViewController, isReversed: Bool) {
        if !isReversed {
            viewController.view.layer.shadowColor = UIColor.black.cgColor
            viewController.view.layer.shadowRadius = 1
            viewController.view.layer.shadowOpacity = 0
            viewController.view.layer.shadowOffset = .zero
            viewController.view.layer.shadowPath = CGPath(rect: viewController.view.bounds, transform: nil)
        }
        
        let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowOpacityAnimation.fromValue = isReversed ? 1 : 0
        shadowOpacityAnimation.toValue = isReversed ? 0 : 1
        
        let shadowRadiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowRadiusAnimation.fromValue = isReversed ? 3 : 1
        shadowRadiusAnimation.toValue = isReversed ? 1 : 3
        
        let shadowAnimation = CAAnimationGroup()
        shadowAnimation.duration = isReversed ? 0.4 : 0.4
        shadowAnimation.timingFunction = CAMediaTimingFunction(name: isReversed ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut)
        shadowAnimation.animations = [shadowOpacityAnimation, shadowRadiusAnimation]
        viewController.view.layer.add(shadowAnimation, forKey: "shadow-animation")
        
        viewController.view.layer.shadowOpacity = isReversed ? 0 : 1
        viewController.view.layer.shadowRadius = isReversed ? 1 : 3
    }
}
