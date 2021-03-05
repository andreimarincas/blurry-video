//
//  BackButton.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/25/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class BackButton: UIControl {
    
    var arrowImageView: UIImageView!
    var textLabel: UILabel!
    
    var textLabelCopy: UILabel?
    var textLabelCopyContainer: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "back-arrow")
        arrowImageView.contentMode = .scaleAspectFit
        addSubview(arrowImageView)
        
        textLabel = UILabel()
        textLabel.font = UIFont.applicationFont(ofSize: 17)
        textLabel.textColor = UIColor(hex: 0x0071ff)
        textLabel.textAlignment = .center
        addSubview(textLabel)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(text: String?) {
        self.init(frame: .zero)
        textLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        arrowImageView.sizeToFit()
        arrowImageView.frame = CGRect(x: margin.left, y: frame.size.height / 2 - arrowImageView.frame.size.height / 2,
                                      width: arrowImageView.frame.size.width, height: arrowImageView.frame.size.height)
        textLabel.sizeToFit()
        textLabel.frame = CGRect(x: arrowImageView.frame.origin.x + arrowImageView.frame.size.width + spacingBetweenArrowAndText,
                                 y: frame.size.height / 2 - textLabel.frame.size.height / 2,
                                 width: textLabel.frame.size.width, height: textLabel.frame.size.height)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                arrowImageView.image = UIImage(named: "back-arrow")?.withAlpha(0.3)
                textLabel.textColor = UIColor(hex: 0x0071ff).withAlphaComponent(0.3)
            } else {
                arrowImageView.image = UIImage(named: "back-arrow")
                textLabel.textColor = UIColor(hex: 0x0071ff)
            }
        }
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        arrowImageView.sizeToFit()
        textLabel.sizeToFit()
        bounds = CGRect(x: 0, y: 0,
                        width: margin.left + arrowImageView.frame.size.width + spacingBetweenArrowAndText + textLabel.frame.size.width + margin.right,
                        height: max(arrowImageView.frame.size.height, textLabel.frame.size.height) + margin.top + margin.bottom)
    }
    
    func copyTextLabel() -> UILabel {
        let newTextLabel = UILabel()
        newTextLabel.text = textLabel.text
        newTextLabel.font = textLabel.font
        newTextLabel.textColor = textLabel.textColor
        newTextLabel.textAlignment = textLabel.textAlignment
        newTextLabel.sizeToFit()
        newTextLabel.frame = textLabel.frame
        return newTextLabel
    }
}

// MARK: - UI Constants

extension BackButton {
    
    var margin: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    var spacingBetweenArrowAndText: CGFloat {
        return 5
    }
}
