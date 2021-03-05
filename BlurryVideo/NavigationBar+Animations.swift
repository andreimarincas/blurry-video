//
//  NavigationBar+Animations.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/26/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

// MARK: - Push
extension NavigationBar {
    
    func preparePushing(_ newController: UIViewController) {
        isUserInteractionEnabled = false
        
        animationBackButton = BackButton(text: titleLabel.text)
        animationBackButton!.frame = frameForBackButton(animationBackButton!)
        animationBackButton!.updateLayout()
        let offset = animationBackButton!.textLabel.frame.leftMiddle
        animationBackButton!.frame = CGRect(origin: titleLabel.frame.leftMiddle.offsetBy(dx: -offset.x, dy: -offset.y), size: animationBackButton!.frame.size)
        
        animationTitleLabel = createTitleLabel(text: titleLabel.text)
        animationTitleLabel!.frame = CGRect(origin: offset.offsetBy(dx: 0, dy: -titleLabel.frame.size.height / 2), size: titleLabel.frame.size)
        animationBackButton!.addSubview(animationTitleLabel!)
        
        animationBackButton!.arrowImageView.alpha = 0
        animationBackButton!.textLabel.alpha = 0
        addSubview(animationBackButton!)
        titleLabel.alpha = 0
        titleLabel.text = newController.title
        titleLabel.frame = frameForTitleLabel(titleLabel)
        
        secondaryAnimationTitleLabel = createTitleLabel(text: newController.title)
        secondaryAnimationTitleLabel!.frame = frameForTitleLabel(secondaryAnimationTitleLabel!).offsetBy(dx: frame.size.width / 2, dy: 0)
        secondaryAnimationTitleLabel!.alpha = 0
        addSubview(secondaryAnimationTitleLabel!)
        
        backButton.preparePushing()
    }
    
    func animatePushing() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.animationBackButton!.alpha = 0.3
        }) { finished in
            guard finished else { return }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.animationBackButton!.frame = self.frameForBackButton(self.animationBackButton!)
                self.animationTitleLabel!.alpha = 0
                self.animationBackButton!.textLabel.alpha = 1
                self.backButton.arrowImageView.alpha = 1
                self.secondaryAnimationTitleLabel!.frame = self.frameForTitleLabel(self.secondaryAnimationTitleLabel!)
                self.secondaryAnimationTitleLabel!.alpha = 1
                
            }) { finished in
                guard finished else { return }
                
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
                    self.animationBackButton!.alpha = 1
                })
            }
        }
        
        backButton.animatePushing()
    }
    
    func finalizePush() {
        backButton.textLabel.text = animationBackButton!.textLabel.text
        backButton.frame = frameForBackButton(backButton)
        backButton.textLabel.alpha = 1
        backButton.arrowImageView.alpha = 1
        titleLabel.alpha = 1
        
        animationBackButton!.removeFromSuperview()
        animationBackButton = nil
        animationTitleLabel = nil
        secondaryAnimationTitleLabel!.removeFromSuperview()
        secondaryAnimationTitleLabel = nil
        
        backButton.finalizePush()
        isUserInteractionEnabled = true
    }
}

// MARK: - Pop
extension NavigationBar {
    
    func preparePopping(backControllerAfterPop backController: UIViewController?) {
        isUserInteractionEnabled = false
        
        animationBackButton = BackButton(text: backButton.textLabel.text)
        animationBackButton!.frame = frameForBackButton(animationBackButton!)
        animationBackButton!.updateLayout()
        let offset = animationBackButton!.textLabel.frame.leftMiddle
        
        animationTitleLabel = createTitleLabel(text: backButton.textLabel.text)
        let animationTitleLabelFrame = frameForTitleLabel(animationTitleLabel!)
        animationTitleLabel!.frame = CGRect(origin: offset.offsetBy(dx: 0, dy: -animationTitleLabelFrame.size.height / 2), size: animationTitleLabelFrame.size)
        animationTitleLabel!.alpha = 0
        animationBackButton!.addSubview(animationTitleLabel!)
        
        animationBackButton!.arrowImageView.alpha = 0
        addSubview(animationBackButton!)
        backButton.textLabel.alpha = 0
        
        secondaryAnimationTitleLabel = createTitleLabel(text: titleLabel.text)
        secondaryAnimationTitleLabel!.frame = frameForTitleLabel(secondaryAnimationTitleLabel!)
        addSubview(secondaryAnimationTitleLabel!)
        
        titleLabel.alpha = 0
        titleLabel.text = backButton.textLabel.text
        titleLabel.frame = frameForTitleLabel(titleLabel)
        backButton.textLabel.text = backController?.title
        backButton.frame = frameForBackButton(backButton)
        backButton.arrowImageView.alpha = (backController != nil) ? 1 : 0.3
        
        backButton.preparePopping()
    }
    
    func animatePopping(backControllerAfterPop backController: UIViewController?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.animationBackButton!.alpha = 0.3
        }) { finished in
            guard finished else { return }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.backButton.arrowImageView.alpha = (backController != nil) ? 1 : 0
                let offset = self.animationBackButton!.textLabel.frame.leftMiddle
                self.animationBackButton!.frame = CGRect(origin: self.titleLabel.frame.leftMiddle.offsetBy(dx: -offset.x, dy: -offset.y), size: self.animationBackButton!.frame.size)
                self.animationBackButton!.textLabel.alpha = 0
                self.animationTitleLabel!.alpha = 1
                self.secondaryAnimationTitleLabel!.frame = self.frameForTitleLabel(self.secondaryAnimationTitleLabel!).offsetBy(dx: self.frame.size.width / 2, dy: 0)
                self.secondaryAnimationTitleLabel!.alpha = 0
            }) { finished in
                guard finished else { return }
                
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
                    self.animationBackButton!.alpha = 1
                })
            }
        }
        
        backButton.animatePopping()
    }
    
    func finalizePop(backControllerAfterPop backController: UIViewController?) {
        backButton.arrowImageView.alpha = (backController != nil) ? 1 : 0
        backButton.textLabel.alpha = 1
        titleLabel.alpha = 1
        
        animationBackButton!.removeFromSuperview()
        animationBackButton = nil
        animationTitleLabel = nil
        secondaryAnimationTitleLabel!.removeFromSuperview()
        secondaryAnimationTitleLabel = nil
        
        backButton.finalizePop()
        isUserInteractionEnabled = true
    }
}
