////
////  TopNavigationBar.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/18/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import CoreGraphics
//
//private let SELECTION_LINE_WIDTH: CGFloat = 4
//private let BOTTOM_LINE_WIDTH: CGFloat = 0.5
//
//protocol NavigationBarDelegate: class {
//
//    func navigationBar(_ navigationBar: NavigationBar, didSelectButton selectedButton: NavigationBar.Button)
//}
//
//class NavigationBar: UIView {
//    
//    enum Button: Int {
//        case library = 0
//        case aspect
//        case blur
//        
//        var localizedTitle: String {
//            switch self {
//            case .library:
//                return "LIBRARY"
//            case .aspect:
//                return "ASPECT"
//            case .blur:
//                return "BLURRING"
//            }
//            // TODO: Localize
//        }
//    }
//    
//    var effectView: UIVisualEffectView!
//    var selectionLine: UIView!
//    var titleButtons: [UIButton] = []
//    
//    var selectedButtonIndex: Int = 0 {
//        didSet {
//            if selectedButtonIndex != oldValue {
//                setNeedsLayout()
//                let selectedButton = titleButtons[selectedButtonIndex]
//                delegate?.navigationBar(self, didSelectButton: Button(rawValue: selectedButton.tag)!)
//            }
//        }
//    }
//    
//    weak var delegate: NavigationBarDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        effectView = addBackgroundBlur(style: .dark, vibrancy: true)
//        backgroundColor = UIColor.white.withAlphaComponent(0.7)
//
//        let libraryButton = createTitleButton(.library)
//        let aspectButton = createTitleButton(.aspect)
//        let blurButton = createTitleButton(.blur)
//        blurButton.isEnabled = false
//        titleButtons = [libraryButton, aspectButton, blurButton]
//        
//        selectionLine = UIView()
//        selectionLine.backgroundColor = UIColor.black
//        addSubview(selectionLine)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func createTitleButton(_ button: Button) -> UIButton {
//        let uiButton = UIButton(type: .custom)
//        uiButton.setTitle(button.localizedTitle, for: .normal)
//        uiButton.titleLabel?.font = UIFont.semiboldApplicationFont(ofSize: 15)
//        uiButton.setTitleColor(UIColor.black, for: .normal)
//        uiButton.setTitleColor(UIColor.lightGray, for: .disabled)
//        uiButton.contentVerticalAlignment = .bottom
//        uiButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: SELECTION_LINE_WIDTH + 2, right: 0)
//        uiButton.tag = button.rawValue
//        uiButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
//        addSubview(uiButton)
//        return uiButton
//    }
//    
//    func enableTitle(button: Button, isEnabled: Bool) {
//        let btn = titleButtons.first { $0.tag == button.rawValue }
//        btn?.isEnabled = isEnabled
//    }
//    
//    @objc private func buttonWasPressed(_ sender: UIButton) {
//        selectedButtonIndex = titleButtons.index(of: sender)!
//        UIView.animate(withDuration: 0.3, delay: 0,
//                       usingSpringWithDamping: 1.8, initialSpringVelocity: 1,
//                       options: [.curveEaseOut, .beginFromCurrentState],
//                       animations: {
//                        self.selectionLine.frame = self.selectionLineFrame
//        }, completion: nil)
//    }
//    
//    var selectionWidth: CGFloat {
//        return frame.size.width / CGFloat(titleButtons.count)
//    }
//    
//    var selectionLineFrame: CGRect {
//        return CGRect(x: CGFloat(selectedButtonIndex) * selectionWidth,
//                      y: frame.size.height - SELECTION_LINE_WIDTH,
//                      width: selectionWidth,
//                      height: SELECTION_LINE_WIDTH).offsetBy(dx: 0, dy: -BOTTOM_LINE_WIDTH)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout() {
//        effectView.frame = bounds.insetBy(top: 0, left: 0, bottom: -BOTTOM_LINE_WIDTH, right: 0)
//        for i in 0..<titleButtons.count {
//            titleButtons[i].frame = CGRect(x: CGFloat(i) * selectionWidth,
//                                           y: 0,
//                                           width: selectionWidth,
//                                           height: frame.size.height - BOTTOM_LINE_WIDTH)
//        }
//        selectionLine.frame = selectionLineFrame
//    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        drawBottomLine(width: BOTTOM_LINE_WIDTH, color: .black)
//    }
//}
