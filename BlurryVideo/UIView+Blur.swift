//
//  UIView+Blur.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBackgroundBlur(style: UIBlurEffectStyle, vibrancy hasVibrancy: Bool) {
        let blur = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: blur)
        if hasVibrancy {
//            let vibrancy = UIVibrancyEffect(blurEffect: blur)
//            effectView.effect = vibrancy
        }
        effectView.frame = bounds
        insertSubview(effectView, at: 0)
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    var backgroundBlurView: UIVisualEffectView? {
        if let effectView = subviews.first as? UIVisualEffectView {
            return effectView
        }
        return nil
    }
}
