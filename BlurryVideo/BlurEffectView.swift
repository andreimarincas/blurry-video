//
//  BlurEffectView.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

//import UIKit
//
//class BlurEffectView: UIView {
//    
//    var effectView: UIVisualEffectView!
//    
//    init(style: UIBlurEffectStyle) {
//        super.init(frame: .zero)
//        backgroundColor = UIColor.white.withAlphaComponent(0.8)
//        let blur = UIBlurEffect(style: style)
//        effectView = UIVisualEffectView(effect: blur)
//        let vibrancy = UIVibrancyEffect(blurEffect: blur)
//        effectView.effect = vibrancy
//        addSubview(effectView)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        effectView.frame = bounds
//    }
//}

