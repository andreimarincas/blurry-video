//
//  BackButton+Animations.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/26/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

private let duration: CFTimeInterval = 0.35
private let opacity: Float = 0.1

// MARK: Push/pop animations
extension BackButton {
    
    func preparePushing() {
        createTextLabelCopyContainer()
        insertSubview(textLabelCopyContainer!, belowSubview: arrowImageView)
        textLabel.alpha = 0
    }
    
    func animatePushing() {
        let positionAnimation = CABasicAnimation(keyPath: "position")
        let oldPosition = textLabelCopy!.layer.position
        let offset = textLabelCopy!.frame.bottomRight.x
        let newPosition = oldPosition.offsetBy(dx: -offset, dy: 0)
        positionAnimation.fromValue = oldPosition
        positionAnimation.toValue = newPosition
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = opacity
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionAnimation, opacityAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationGroup.duration = duration
        textLabelCopy!.layer.add(animationGroup, forKey: "slide-letters-in")
        textLabelCopy!.layer.position = newPosition
        textLabelCopy!.layer.opacity = opacity
    }
    
    func finalizePush() {
        removeTextLabelCopyContainer()
    }
    
    func preparePopping() {
        createTextLabelCopyContainer()
        CALayer.performWithoutAnimation {
            let oldPosition = self.textLabelCopy!.layer.position
            let offset = self.textLabelCopy!.frame.bottomRight.x
            self.textLabelCopy!.layer.position = oldPosition.offsetBy(dx: -offset, dy: 0)
            self.textLabelCopy!.layer.opacity = opacity
        }
        insertSubview(textLabelCopyContainer!, belowSubview: arrowImageView)
        textLabel.alpha = 0
    }
    
    func animatePopping() {
        let positionAnimation = CABasicAnimation(keyPath: "position")
        let oldPosition = textLabelCopy!.layer.position
        let offset = textLabelCopy!.frame.size.width + leftOffset
        let newPosition = oldPosition.offsetBy(dx: offset, dy: 0)
        positionAnimation.fromValue = oldPosition
        positionAnimation.toValue = newPosition
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = opacity
        opacityAnimation.toValue = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionAnimation, opacityAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationGroup.duration = duration
        textLabelCopy!.layer.add(animationGroup, forKey: "slide-letters-out")
        textLabelCopy!.layer.position = newPosition
        textLabelCopy!.layer.opacity = 1
    }
    
    func finalizePop() {
        removeTextLabelCopyContainer()
    }
}

private extension BackButton {
    
    func createTextLabelCopyContainer() {
        textLabelCopyContainer = UIView()
        textLabelCopyContainer!.layer.masksToBounds = true
        textLabelCopyContainer!.frame = textLabel.frame.insetBy(top: 0, left: -leftOffset, bottom: 0, right: 0)
        textLabelCopy = copyTextLabel()
        textLabelCopy!.frame = CGRect(origin: CGPoint(x: leftOffset, y: 0), size: textLabel.frame.size)
        textLabelCopy!.textColor = UIColor(hex: 0x0071ff)
        textLabelCopyContainer!.addSubview(textLabelCopy!)
    }
    
    func removeTextLabelCopyContainer() {
        textLabelCopyContainer!.removeFromSuperview()
        textLabelCopyContainer = nil
        textLabelCopy = nil
    }
    
    // Distance from the tip of the arrow (approx.) to where the text begins (origin of the textLabel)
    var leftOffset: CGFloat {
        return spacingBetweenArrowAndText + arrowImageView.frame.size.width / 2
    }
}
