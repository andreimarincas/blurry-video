//
//  UIViewController+NavigationController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/26/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Returns the first parent in the view-controller hierarchy which is of type NavigationController.
    var customNavigationController: NavigationController? {
        var controller = self.parent
        while controller != nil {
            if let navigationController = controller as? NavigationController {
                return navigationController
            }
            controller = controller?.parent
        }
        return nil
    }
    
    var navigationBarHeight: CGFloat {
        guard let navigationController = customNavigationController else { return 0 }
        return navigationController.navigationBar.frame.size.height
    }
}

// MARK: Navigation bar appearance update
extension UIViewController {
    
    func setNeedsNavigationBarAppearanceUpdate() {
        if let navigationController = self.customNavigationController {
            navigationController.updateNavigationBarAppearance(for: self)
        }
    }
    
    var prefersNavigationBarHidden: Bool {
        if let navigationController = self.customNavigationController {
            return navigationController.isNavigationBarHidden
        }
        return false
    }
}
