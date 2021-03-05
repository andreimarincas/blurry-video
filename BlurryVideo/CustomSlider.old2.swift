////
////  CustomSlider.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/19/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import QuartzCore
//
//class CustomSlider: UIView {
//    
//    var progress: CGFloat = 0.5 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    
//    var minimumValue: CGFloat = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    
//    var maximumValue: CGFloat = 1 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    
//    var animationDurationOnProgressChange: TimeInterval = 0.1
//    
//    var isEnabled: Bool = true {
//        didSet {
//            isUserInteractionEnabled = isEnabled
//        }
//    }
//    
//    private var effectView: UIVisualEffectView!
//    private var contentView: UIView!
//    private var leftLayer: CALayer!
//    private var rightLayer: CALayer!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        layer.masksToBounds = true
//        
//        effectView = addBackgroundBlur(style: .dark, vibrancy: true)
//        
//        contentView = UIView()
//        contentView.backgroundColor = .clear
//        addSubview(contentView)
//        
//        leftLayer = CALayer()
//        leftLayer.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
//        contentView.layer.addSublayer(leftLayer)
//        
//        rightLayer = CALayer()
//        rightLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.3).cgColor
//        contentView.layer.addSublayer(rightLayer)
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
//    func updateLayout() {
//        CALayer.performWithoutAnimation {
//            self.layer.cornerRadius = self.frame.size.height / 2
//        }
//        effectView.frame = bounds
//        contentView.frame = bounds
//        updateProgress(animated: false)
//    }
//    
//    private func updateProgress(animated: Bool) {
//        let progress = clamp(self.progress, min: minimumValue, max: maximumValue)
//        let range = max(maximumValue - minimumValue, 0)
//        let rate: CGFloat = (range > 0) ? progress / range : 0
//        let progressX = rate * contentView.frame.size.width
//        let leftRect = CGRect(x: 0, y: 0, width: progressX, height: contentView.frame.size.height)
//        let rigthRect = CGRect(x: progressX, y: 0, width: contentView.frame.size.width - progressX, height: contentView.frame.size.height)
//        CALayer.animate(withDuration: animated ? animationDurationOnProgressChange : 0, animations: {
//            self.leftLayer.frame = leftRect
//            self.rightLayer.frame = rigthRect
//        })
//    }
//    
//    func setProgress(_ progress: CGFloat, animated: Bool) {
//        self.progress = progress
//        updateProgress(animated: true)
//    }
//}
