//
//  NavigationBar.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class NavigationBar: UIView {
    
    var titleLabel: UILabel!
    var backButton: BackButton!
    
    var animationTitleLabel: UILabel?
    var animationBackButton: BackButton?
    var secondaryAnimationTitleLabel: UILabel?
    
    weak var navigationController: NavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackgroundBlur(style: .light, vibrancy: true)
        
        titleLabel = createTitleLabel()
        addSubview(titleLabel)
        
        backButton = BackButton()
        backButton.arrowImageView.alpha = 0
        addSubview(backButton)
    }
    
    convenience init(title: String?) {
        self.init(frame: .zero)
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        backgroundBlurView?.frame = bounds.insetBy(top: 0, left: 0, bottom: -bottomLineWidth, right: 0)
        titleLabel.frame = frameForTitleLabel(titleLabel)
        backButton.frame = frameForBackButton(backButton)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBottomLine(width: bottomLineWidth, color: .black)
    }
}

// MARK: - Factory
extension NavigationBar {
    
    func createTitleLabel(text: String? = nil) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.semiboldApplicationFont(ofSize: 17)
        titleLabel.text = text
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }
}

// MARK: - UI Constants

private let bottomLineWidth: CGFloat = 0.5

extension NavigationBar {
    
    var backButtonMinSize: CGSize {
        return CGSize(width: 60, height: isPortrait ? 44 : 32)
    }
    
    func frameForTitleLabel(_ titleLabel: UILabel) -> CGRect {
        titleLabel.sizeToFit()
        let center = CGPoint(x: frame.size.width / 2, y: statusBarHeight + (frame.size.height - statusBarHeight) / 2)
        return CGRect(center: center, size: titleLabel.frame.size)
    }
    
    func frameForBackButton(_ backButton: BackButton) -> CGRect {
        backButton.sizeToFit()
        return CGRect(x: 0, y: statusBarHeight,
                      width: max(backButton.frame.size.width, backButtonMinSize.width),
                      height: max(backButton.frame.size.height, backButtonMinSize.height))
            .insetBy(top: 0, left: 0, bottom: -bottomLineWidth, right: 0)
    }
    
    var statusBarHeight: CGFloat {
        return navigationController?.statusBarHeight ?? 0
    }
}
