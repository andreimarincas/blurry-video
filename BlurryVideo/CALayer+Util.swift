//
//  CALayer+Util.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/15/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation
import QuartzCore

extension CALayer {
    
    class func performWithoutAnimation(_ actionsBlock: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        actionsBlock?()
        CATransaction.commit()
    }
    
    class func animate(withDuration duration: TimeInterval, animations: (() -> Void)?) {
        guard duration > 0 else {
            CALayer.performWithoutAnimation(animations)
            return
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanFalse, forKey: kCATransactionDisableActions)
        CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
        animations?()
        CATransaction.commit()
    }
}
