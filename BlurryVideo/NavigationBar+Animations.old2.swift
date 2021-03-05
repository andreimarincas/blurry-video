////
////  NavigationBar+Animations.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/26/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//
//// MARK: - Push
//extension NavigationBar {
//    
//    func prepareForPushing(_ newController: UIViewController) {
//        isUserInteractionEnabled = false
//        
//        animationTitleLabel = createTitleLabel(text: titleLabel.text)
//        animationTitleLabel!.frame = frameForTitleLabel(animationTitleLabel!)
//        addSubview(animationTitleLabel!)
//        
//        titleLabel.alpha = 0
//        titleLabel.text = newController.title
//        titleLabel.frame = frameForTitleLabel(titleLabel)
//        
//        secondaryAnimationTitleLabel = createTitleLabel(text: newController.title)
//        secondaryAnimationTitleLabel!.frame = frameForTitleLabel(secondaryAnimationTitleLabel!).offsetBy(dx: frame.size.width / 2, dy: 0)
//        secondaryAnimationTitleLabel!.alpha = 0
//        addSubview(secondaryAnimationTitleLabel!)
//    }
//    
//    func animatePushing() {
//        UIView.animate(withDuration: 0.05, animations: {
//            self.animationTitleLabel!.alpha = 0.3
//        }) { finished in
//            guard finished else { return }
//            
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
//                let leftMiddle = self.convert(self.backButton.textLabel.frame.leftMiddle, from: self.backButton)
//                self.animationTitleLabel!.frame = CGRect(origin: leftMiddle.offsetBy(dx: 0, dy: -self.animationTitleLabel!.frame.size.height / 2), size: self.animationTitleLabel!.frame.size)
//                self.backButton.textLabel.alpha = 0
//                self.backButton.arrowImageView.alpha = 1
//                self.secondaryAnimationTitleLabel!.frame = self.frameForTitleLabel(self.secondaryAnimationTitleLabel!)
//                self.secondaryAnimationTitleLabel!.alpha = 0.3
//            }) { finished in
//                guard finished else { return }
//                self.backButton.textLabel.text = self.animationTitleLabel!.text
//                self.backButton.frame = self.frameForBackButton(self.backButton)
//                
//                UIView.animate(withDuration: 0.15, animations: {
//                    self.backButton.textLabel.alpha = 1
//                    self.animationTitleLabel!.alpha = 0
//                    self.secondaryAnimationTitleLabel!.alpha = 1
//                })
//            }
//        }
//    }
//    
//    func finalizePush() {
//        backButton.arrowImageView.alpha = 1
//        backButton.textLabel.text = animationTitleLabel!.text
//        backButton.frame = frameForBackButton(backButton)
//        backButton.textLabel.alpha = 1
//        titleLabel.alpha = 1
//        
//        animationTitleLabel!.removeFromSuperview()
//        animationTitleLabel = nil
//        secondaryAnimationTitleLabel!.removeFromSuperview()
//        secondaryAnimationTitleLabel = nil
//        
//        isUserInteractionEnabled = true
//    }
//}
//
//// MARK: - Pop
//extension NavigationBar {
//    
//    func prepareForPopping(backControllerAfterPop backController: UIViewController?) {
//        isUserInteractionEnabled = false
//        
////        animationBackButton = BackButton(text: backButton.textLabel.text)
////        animationBackButton!.frame = frameForBackButton(animationBackButton!)
////        animationBackButton!.updateLayout()
////        let offset = animationBackButton!.textLabel.frame.leftMiddle
////        
////        animationTitleLabel = createTitleLabel(text: backButton.textLabel.text)
////        let animationTitleLabelFrame = frameForTitleLabel(animationTitleLabel!)
////        animationTitleLabel!.frame = CGRect(origin: offset.offsetBy(dx: 0, dy: -animationTitleLabelFrame.size.height / 2), size: animationTitleLabelFrame.size)
////        animationTitleLabel!.alpha = 0
////        animationBackButton!.addSubview(animationTitleLabel!)
////        
////        animationBackButton!.arrowImageView.alpha = 0
////        addSubview(animationBackButton!)
////        backButton.textLabel.alpha = 0
////        
////        secondaryAnimationTitleLabel = createTitleLabel(text: titleLabel.text)
////        secondaryAnimationTitleLabel!.frame = frameForTitleLabel(secondaryAnimationTitleLabel!)
////        addSubview(secondaryAnimationTitleLabel!)
////        
////        titleLabel.alpha = 0
////        titleLabel.text = backButton.textLabel.text
////        titleLabel.frame = frameForTitleLabel(titleLabel)
////        backButton.textLabel.text = backController?.title
////        backButton.frame = frameForBackButton(backButton)
//    }
//    
//    func animatePopping(backControllerAfterPop backController: UIViewController?) {
////        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
////            self.backButton.arrowImageView.alpha = (backController != nil) ? 1 : 0
////            self.backButton.textLabel.alpha = 1
////            let offset = self.animationBackButton!.textLabel.frame.leftMiddle
////            self.animationBackButton!.frame = CGRect(origin: self.titleLabel.frame.leftMiddle.offsetBy(dx: -offset.x, dy: -offset.y), size: self.animationBackButton!.frame.size)
////            self.animationBackButton!.textLabel.alpha = 0
////            self.animationTitleLabel!.alpha = 1
////            self.secondaryAnimationTitleLabel!.frame = self.frameForTitleLabel(self.secondaryAnimationTitleLabel!).offsetBy(dx: self.frame.size.width / 2, dy: 0)
////            self.secondaryAnimationTitleLabel!.alpha = 0
////        }) { (finished: Bool) in
////            
////        }
//    }
//    
//    func finalizePop() {
////        titleLabel.alpha = 1
////        animationBackButton!.removeFromSuperview()
////        animationBackButton = nil
////        animationTitleLabel = nil
////        secondaryAnimationTitleLabel!.removeFromSuperview()
////        secondaryAnimationTitleLabel = nil
//        
//        isUserInteractionEnabled = true
//    }
//}
