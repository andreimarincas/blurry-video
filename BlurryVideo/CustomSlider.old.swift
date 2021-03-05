////
////  CustomSlider.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/15/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import QuartzCore
//
//class CustomSlider: UIView {
//    
//    private var leftLayer: CALayer!
//    private var rightLayer: CALayer!
//    
//    private var _minValue: CGFloat = 0
//    var minimumValue: CGFloat {
//        get {
//            return _minValue
//        }
//        set {
//            _minValue = newValue
//            updateLayout()
//        }
//    }
//    
//    private var _maxValue: CGFloat = 1
//    var maximumValue: CGFloat {
//        get {
//            return _maxValue
//        }
//        set {
//            _maxValue = newValue
//            updateLayout()
//        }
//    }
//    
//    private var _progress: CGFloat = 0
//    var progress: CGFloat {
//        get {
//            return _progress
//        }
//        set {
//            _progress = clamp(newValue, toMin: minimumValue, max: maximumValue)
//            updateLayout()
//        }
//    }
//    
//    var effectView: UIVisualEffectView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        layer.cornerRadius = frame.size.height / 2
//        layer.masksToBounds = true
//        
////        effectView = addBackgroundBlur(style: .dark, vibrancy: true)
//        
//        leftLayer = CALayer()
//        leftLayer.backgroundColor = UIColor.red.cgColor
//        leftLayer.opacity = 0.5
//        layer.addSublayer(leftLayer)
//        
//        rightLayer = CALayer()
//        rightLayer.backgroundColor = UIColor.black.cgColor
//        rightLayer.opacity = 0.5
//        layer.addSublayer(rightLayer)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout(animated: Bool = false) {
//        let rate: CGFloat = maximumValue > 0 ? progress / maximumValue : 0
//        let progressX = rate * frame.size.width
//        let leftRect = CGRect(x: 0, y: 0, width: progressX, height: frame.size.height)
//        let rigthRect = CGRect(x: progressX, y: 0, width: frame.size.width - progressX, height: frame.size.height)
//        if animated {
//            CALayer.animate(withDuration: 0.1, actionsBlock: {
//                self.leftLayer.frame = leftRect
//                self.rightLayer.frame = rigthRect
//            })
//        } else {
//            CALayer.performWithoutAnimation {
//                self.leftLayer.frame = leftRect
//                self.rightLayer.frame = rigthRect
//            }
//        }
//        CALayer.performWithoutAnimation {
//            self.layer.cornerRadius = self.frame.size.height / 2
//        }
//    }
//    
//    func setProgress(_ progress: CGFloat, animated: Bool) {
//        if animated {
//            _progress = clamp(progress, toMin: minimumValue, max: maximumValue)
//            updateLayout(animated: true)
//        } else {
//            self.progress = progress
//        }
//    }
//}
