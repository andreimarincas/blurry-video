//
//  BlurryPlayerView.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class BlurryPlayerView: PlayerView {
    
    var effectViewContainer: UIView!
    
    init() {
        super.init(frame: .zero)
        effectViewContainer = UIView()
        effectViewContainer.addBackgroundBlur(style: .dark, vibrancy: true)
        effectViewContainer.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        addSubview(effectViewContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        effectViewContainer.frame = bounds
        effectViewContainer.backgroundBlurView!.frame = effectViewContainer.bounds
    }
}
