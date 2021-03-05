//
//  MainViewController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/22/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    weak var viewControllerForStatusBarAppearance: UIViewController? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        if let vc = viewControllerForStatusBarAppearance, vc != self {
            return vc.prefersStatusBarHidden
        }
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = viewControllerForStatusBarAppearance, vc != self {
            return vc.preferredStatusBarStyle
        }
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let vc = viewControllerForStatusBarAppearance, vc != self  {
            return vc.preferredStatusBarUpdateAnimation
        }
        return .fade
    }
}
