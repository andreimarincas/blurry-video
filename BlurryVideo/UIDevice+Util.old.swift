//
//  UIDevice+Util.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/18/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

//import UIKit
//
//extension UIDevice {
//    
//    static var isIPad: Bool {
//        return UIDevice.current.userInterfaceIdiom == .pad
//    }
//    
//    static var isIPhone: Bool {
//        return UIDevice.current.userInterfaceIdiom == .phone
//    }
//    
//    static var screen: UIScreen {
//        return UIScreen.main
//    }
//    
//    static var isRetina: Bool {
//        return screen.scale >= 2.0
//    }
//    
//    static var screenWidth: Int {
//        return Int(screen.bounds.size.width)
//    }
//    
//    static var screenHeight: Int {
//        return Int(screen.bounds.size.height)
//    }
//    
//    static var screenMinLength: Int {
//        return min(screenWidth, screenHeight)
//    }
//    
//    static var screenMaxLength: Int {
//        return max(screenWidth, screenHeight)
//    }
//    
//    static var isIPhone4OrLess: Bool {
//        return isIPhone && screenMaxLength < 568
//    }
//    
//    static var isIPhone5: Bool {
//        return isIPhone && screenMaxLength == 568
//    }
//    
//    static var isIPhone6: Bool {
//        return isIPhone && screenMaxLength == 667
//    }
//    
//    static var isIPhone6P: Bool {
//        return isIPhone && screenMaxLength == 736
//    }
//    
//    static var isIPhoneX: Bool {
//        return isIPhone && screenMaxLength == 812
//    }
//}
