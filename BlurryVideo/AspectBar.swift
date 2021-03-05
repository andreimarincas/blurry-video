//
//  AspectBar.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/17/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

protocol AspectBarDelegate: class {
    
    func aspectBar(_ bar: AspectBar, didChangeAspect newAspect: Aspect)
}

class AspectBar: UIView {
    
    var buttons: [AspectButton] = []
    var selectedButton: AspectButton?
    weak var delegate: AspectBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackgroundBlur(style: .light, vibrancy: true)
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        buttons = [
            AspectButton(aspect: .fullscreen),
            AspectButton(aspect: .fullscreenPortrait),
            AspectButton(aspect: .widescreen),
            AspectButton(aspect: .widescreenPortrait)
        ]
        
        for btn in buttons {
            btn.addTarget(self, action: #selector(selectionWasChanged(_:)), for: .valueChanged)
            addSubview(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectAspect(_ aspect: Aspect, isSelected: Bool) {
        buttons.first(where: { $0.aspect == aspect })?.isSelected = isSelected
    }
    
    @objc private func selectionWasChanged(_ sender: UIControl) {
        logIN()
        let btn = sender as! AspectButton
        if btn.isSelected {
            selectedButton?.isSelected = false
            selectedButton = btn
            delegate?.aspectBar(self, didChangeAspect: btn.aspect)
        }
        logOUT()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        let spacing: CGFloat = (frame.size.width - CGFloat(buttons.count) * aspectButtonSize.width) / CGFloat(buttons.count + 1)
        var buttonX: CGFloat = spacing
        let buttonY: CGFloat = frame.size.height / 2 - aspectButtonSize.height / 2
        for btn in buttons {
            btn.frame = CGRect(origin: CGPoint(x: buttonX, y: buttonY), size: aspectButtonSize)
            buttonX += aspectButtonSize.width + spacing
        }
        backgroundBlurView?.frame = bounds.insetBy(top: topLineWidth, left: 0, bottom: 0, right: 0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTopLine(width: topLineWidth, color: .black)
    }
}

// MARK: - UI Constants

private let topLineWidth: CGFloat = 0.5

extension AspectBar {
    
    var aspectButtonSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}
