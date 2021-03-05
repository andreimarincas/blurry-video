////
////  CustomSlider.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/19/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//
//protocol CustomSliderDelegate: class {
//    
//    func slider(_ slider: CustomSlider, didChangeTracking isTracking: Bool)
//}
//
//class CustomSlider: UISlider {
//    
//    weak var delegate: CustomSliderDelegate?
//    
//    var lastKnownThumbRect: CGRect = .zero
//    
//    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
//        let thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
//        lastKnownThumbRect = thumbRect
//        return thumbRect
//    }
//    
//    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
////        let shouldContinueTracking = super.beginTracking(touch, with: event)
////        delegate?.slider(self, didChangeTracking: shouldContinueTracking)
////        return shouldContinueTracking
//        
////        delegate?.slider(self, didChangeTracking: true)
////        return true
//        
//        super.beginTracking(touch, with: event)
//        delegate?.slider(self, didChangeTracking: true)
////        let touch: UITouch = touches.first as! UITouch
//        let touchLocation = touch.location(in: self)
//        // If we didn't tap on the thumb button then we set the value based on tap location.
//        if !lastKnownThumbRect.contains(touchLocation) {
//            let newValue = minimumValue + Float(touchLocation.x / self.frame.size.width) * (maximumValue - minimumValue)
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
//                self.setValue(newValue, animated: true)
//            }, completion: nil)
//        }
//        return true
//    }
//    
//    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        super.continueTracking(touch, with: event)
//        delegate?.slider(self, didChangeTracking: true)
//        return true
//    }
//    
//    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        super.endTracking(touch, with: event)
//        delegate?.slider(self, didChangeTracking: false)
//    }
//    
//    override func cancelTracking(with event: UIEvent?) {
//        super.cancelTracking(with: event)
//        delegate?.slider(self, didChangeTracking: false)
//    }
//}
//
////-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////    
////    UITouch *touch = [[event allTouches] anyObject];
////    CGPoint touchLocation = [touch locationInView:self];
////    
////    // if we didn't tap on the thumb button then we set the value based on tap location
////    if (!CGRectContainsPoint(lastKnownThumbRect, touchLocation)) {
////        
////        self.value = self.minimumValue + (self.maximumValue - self.minimumValue) * (touchLocation.x / self.frame.size.width);
////    }
////    
////    [super touchesBegan:touches withEvent:event];
////    }
////    
////    - (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
////        
////        CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
////        lastKnownThumbRect = thumbRect;
////        return thumbRect;
////}
