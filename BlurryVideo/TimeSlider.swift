//
//  TimeSlider.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

protocol TimeSliderDelegate: class {
    
    func slider(_ slider: TimeSlider, didChangeTracking isTracking: Bool)
}

class TimeSlider: UISlider {
    
    weak var delegate: TimeSliderDelegate?
    private var lastKnownThumbRect: CGRect = .zero
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        lastKnownThumbRect = thumbRect
        return thumbRect
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        delegate?.slider(self, didChangeTracking: true)
        let touchLocation = touch.location(in: self)
        // If we didn't tap on the thumb button then we set the value based on tap location.
        if !lastKnownThumbRect.contains(touchLocation) {
            value = minimumValue + Float(touchLocation.x / self.frame.size.width) * (maximumValue - minimumValue)
        }
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        delegate?.slider(self, didChangeTracking: true)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        delegate?.slider(self, didChangeTracking: false)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        delegate?.slider(self, didChangeTracking: false)
    }
}
