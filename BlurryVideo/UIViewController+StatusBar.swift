//
//  UIViewController+StatusBar.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/26/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var statusBarHeight: CGFloat {
        if prefersStatusBarHidden {
            return 0
        }
        return 20
    }
}
