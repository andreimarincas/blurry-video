//
//  AspectButton.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/16/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class AspectButton: UIControl {
    
    var label: UILabel!
    let aspect: Aspect
    
    var aspectRectInset: CGFloat = 6 {
        didSet {
            updateUI()
        }
    }
    
    init(aspect: Aspect) {
        self.aspect = aspect
        super.init(frame: .zero)
        backgroundColor = .clear
        
        label = UILabel()
        label.font = UIFont.boldApplicationFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
//        label.text = aspect?.rawValue ?? "Custom"
        label.text = "\(aspect.width):\(aspect.height)"
        addSubview(label)
        
        addTarget(self, action: #selector(onPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onPressed() {
        isSelected = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                updateUI()
                sendActions(for: .valueChanged)
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }
    
//    func color(for state: UIControlState) -> UIColor {
//        if state.contains(.selected) {
//            return .red
//        }
//        return .yellow
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func updateUI() {
        label.sizeToFit()
        let labelMarginBottom: CGFloat = 4
        label.center = CGPoint(x: frame.size.width / 2, y: frame.size.height - label.bounds.size.height / 2 - labelMarginBottom)
//        label.textColor = color(for: state)
        if state.contains(.selected) {
//            layer.backgroundColor = UIColor(white: 0.3, alpha: 1.0).cgColor
            layer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
            layer.cornerRadius = 8
            layer.masksToBounds = true
        } else {
            layer.backgroundColor = nil
        }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        let availableRect = CGRect(x: 0, y: 0, width: frame.size.width, height: label.frame.origin.y).insetBy(dx: aspectRectInset, dy: aspectRectInset)
        let availableLength = min(availableRect.size.width, availableRect.size.height)
        var aspectSize: CGSize = .zero
        let ratio = CGFloat(aspect.ratio)
        if aspect.width >= aspect.height {
            aspectSize.width = availableLength
            aspectSize.height = availableLength * (1.0 / ratio)
        } else {
            aspectSize.width = availableLength * ratio
            aspectSize.height = availableLength
        }
        let aspectCenter = CGPoint(x: availableRect.origin.x + availableRect.size.width / 2,
                                          y: availableRect.origin.y + availableRect.size.height / 2)
        let lineWidth: CGFloat = 3
        let aspectRect = CGRect(origin: CGPoint(x: aspectCenter.x - aspectSize.width / 2, y: aspectCenter.y - aspectSize.height / 2),
                                size: aspectSize).insetBy(dx: lineWidth, dy: lineWidth)
        context.setLineWidth(lineWidth)
        context.setLineJoin(.round)
//        context.setStrokeColor(color(for: state).cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.stroke(aspectRect.integral)
        context.restoreGState()
    }
}
