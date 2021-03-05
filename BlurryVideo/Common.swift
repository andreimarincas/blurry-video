//
//  Common.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/16/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

//let statusBarHeight: CGFloat = 20 // TODO: Calculate status bar height from UIScreen

//var statusBarHeight: CGFloat {
//    let frame = UIApplication.shared.statusBarFrame
//    return min(frame.width, frame.height)
//}

var interfaceOrientation: UIInterfaceOrientation {
    return UIApplication.shared.statusBarOrientation
}

var isPortrait: Bool {
    return interfaceOrientation.isPortrait
}

var isLandscape: Bool {
    return interfaceOrientation.isLandscape
}
