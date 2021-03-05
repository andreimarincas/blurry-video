//
//  CustomFont.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/12/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

enum FontStyle: String {
    
    case normal   = ""
    case light    = "-light"
    case semibold = "-semibold"
    case bold     = "-bold"
    
    static let `default` = FontStyle.normal
}

private let DEFAULT_FONT_NAME: String = "OpenSans"
private let DEFAULT_FONT_SIZE: CGFloat = 12

struct CustomFont {
    
    var familyName: String
    var style: FontStyle
    var size: CGFloat
    
    static var current: CustomFont = CustomFont(familyName: DEFAULT_FONT_NAME)!
    
    init?(familyName: String, style: FontStyle, size: CGFloat) {
        guard familyName.length > 0 else { return nil } // TODO: Check also if the font resource exists
        guard size > 0 else { return nil }
        
        self.familyName = familyName
        self.style = style
        self.size = size
    }
    
    var name: String {
        return familyName + style.rawValue
    }
    
    func withStyle(_ style: FontStyle) -> CustomFont {
        var font = self
        font.style = style
        return font
    }
    
    func ofSize(_ size: CGFloat) -> UIFont? {
        return UIFont(name: name, size: size)
    }
}

extension CustomFont {
    
    init?(familyName: String) {
        self.init(familyName: familyName, style: .default, size: DEFAULT_FONT_SIZE)
    }
    
    init?(familyName: String, style: FontStyle) {
        self.init(familyName: familyName, style: style, size: DEFAULT_FONT_SIZE)
    }
    
    init?(familyName: String, size: CGFloat) {
        self.init(familyName: familyName, style: .default, size: size)
    }
}

extension UIFont
{
    class func applicationFont(ofSize size: CGFloat) -> UIFont {
        let font = CustomFont.current.withStyle(.normal)
        return font.ofSize(size)!
    }
    
    class func lightApplicationFont(ofSize size: CGFloat) -> UIFont {
        let font = CustomFont.current.withStyle(.light)
        return font.ofSize(size)!
    }
    
    class func semiboldApplicationFont(ofSize size: CGFloat) -> UIFont {
        let font = CustomFont.current.withStyle(.semibold)
        return font.ofSize(size)!
    }
    
    class func boldApplicationFont(ofSize size: CGFloat) -> UIFont {
        let font = CustomFont.current.withStyle(.bold)
        return font.ofSize(size)!
    }
}
