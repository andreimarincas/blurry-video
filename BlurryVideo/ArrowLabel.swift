////
////  ArrowLabel.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/16/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import Foundation
//import QuartzCore
//import CoreGraphics
//import UIKit
//
//class ArrowLabel: UIView {
//    
//    enum ArrowDirection {
//        case up
//        case down
//    }
//    
//    private var textLabel: UILabel!
//    
//    private var _backgroundColor: UIColor? = UIColor.red
//    override var backgroundColor: UIColor? {
//        set {
//            _backgroundColor = newValue
//            setNeedsDisplay()
//        }
//        get {
//            return _backgroundColor
//        }
//    }
//    
//    var arrowDirection: ArrowDirection = .up {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    var arrowBase: CGFloat = 10 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    var arrowHeight: CGFloat = 8 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    var tipHeight: CGFloat = 5 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    var baseCurveHeight: CGFloat = 5 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//    
//    var font = UIFont.applicationFont(ofSize: 10) {
//        didSet {
//            textLabel.font = font
//            updateUI()
//        }
//    }
//    
//    var text: String = "" {
//        didSet {
//            textLabel.text = text
//            updateUI()
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        super.backgroundColor = .clear
//        textLabel = UILabel()
//        textLabel.textAlignment = .center
//        textLabel.text = text
//        textLabel.font = font
//        addSubview(textLabel)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateUI()
//    }
//    
//    func updateUI() {
//        textLabel.sizeToFit()
//        textLabel.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
//        setNeedsDisplay()
//    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        context.saveGState()
//        let contentRect = bounds.insetBy(dx: arrowHeight, dy: arrowHeight)
//        let contentPath = UIBezierPath(roundedRect: contentRect, cornerRadius: 5)
//        context.addPath(contentPath.cgPath)
//        
//        func drawArrowPath(_ baseLeft: CGPoint,
//                           _ baseLeft1: CGPoint,
//                           _ baseLeft2: CGPoint,
//                           _ baseRight: CGPoint,
//                           _ baseRight1: CGPoint,
//                           _ baseRight2: CGPoint,
//                           _ tip: CGPoint,
//                           _ tipBaseLeft: CGPoint,
//                           _ tipBaseRight: CGPoint) {
//            
//            let arrowPath = UIBezierPath()
//            arrowPath.move(to: baseLeft1)
//            arrowPath.addQuadCurve(to: baseLeft2, controlPoint: baseLeft)
//            arrowPath.addLine(to: tipBaseLeft)
//            arrowPath.addQuadCurve(to: tipBaseRight, controlPoint: tip)
//            arrowPath.addLine(to: baseRight1)
//            arrowPath.addQuadCurve(to: baseRight2, controlPoint: baseRight)
//            arrowPath.close()
//            context.addPath(arrowPath.cgPath)
//        }
//        
//        switch arrowDirection {
//        case .up:
//            let base = CGPoint(x: frame.size.width / 2, y: arrowHeight)
//            let baseLeft = CGPoint(x: base.x - arrowBase / 2, y: base.y)
//            let baseRight = CGPoint(x: base.x + arrowBase / 2, y: base.y)
//            let tip = CGPoint(x: base.x, y: base.y - arrowHeight)
//            
//            let tipBase: CGFloat = (tipHeight / arrowHeight) * arrowBase
//            let tipBaseLeft = CGPoint(x: base.x - tipBase / 2, y: tip.y + tipHeight)
//            let tipBaseRight = CGPoint(x: base.x + tipBase / 2, y: tip.y + tipHeight)
//            
//            let baseCurveWidth: CGFloat = (baseCurveHeight / arrowHeight) * arrowBase
//            let baseLeft1 = CGPoint(x: baseLeft.x - baseCurveWidth, y: base.y)
//            let baseLeft2 = CGPoint(x: baseLeft.x + baseCurveWidth / 2, y: base.y - baseCurveHeight)
//            let baseRight1 = CGPoint(x: baseRight.x - baseCurveWidth / 2, y: base.y - baseCurveHeight)
//            let baseRight2 = CGPoint(x: baseRight.x + baseCurveWidth, y: base.y)
//            
//            drawArrowPath(baseLeft, baseLeft1, baseLeft2, baseRight, baseRight1, baseRight2, tip, tipBaseLeft, tipBaseRight)
//            break
//        case .down:
//            let base = CGPoint(x: frame.size.width / 2, y: frame.size.height - arrowHeight)
//            let baseLeft = CGPoint(x: base.x - arrowBase / 2, y: base.y)
//            let baseRight = CGPoint(x: base.x + arrowBase / 2, y: base.y)
//            let tip = CGPoint(x: base.x, y: base.y + arrowHeight)
//            
//            let tipBase: CGFloat = (tipHeight / arrowHeight) * arrowBase
//            let tipBaseLeft = CGPoint(x: base.x - tipBase / 2, y: tip.y - tipHeight)
//            let tipBaseRight = CGPoint(x: base.x + tipBase / 2, y: tip.y - tipHeight)
//            
//            let baseCurveWidth: CGFloat = (baseCurveHeight / arrowHeight) * arrowBase
//            let baseLeft1 = CGPoint(x: baseLeft.x - baseCurveWidth, y: base.y)
//            let baseLeft2 = CGPoint(x: baseLeft.x + baseCurveWidth / 2, y: base.y + baseCurveHeight)
//            let baseRight1 = CGPoint(x: baseRight.x - baseCurveWidth / 2, y: base.y + baseCurveHeight)
//            let baseRight2 = CGPoint(x: baseRight.x + baseCurveWidth, y: base.y)
//            
//            drawArrowPath(baseLeft, baseLeft1, baseLeft2, baseRight, baseRight1, baseRight2, tip, tipBaseLeft, tipBaseRight)
//            break
//        }
//        
//        if let bgColor = backgroundColor {
//            context.setFillColor(bgColor.cgColor)
//        }
//        context.fillPath()
//        
//        context.restoreGState()
//    }
//}
