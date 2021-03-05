//
//  NavigationController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class NavigationController: UIViewController {
    
    var rootViewController: UIViewController!
    
    var currentController: UIViewController! {
        didSet {
            viewControllerForNavigationBarAppearance = currentController
        }
    }
    
    var navigationBar: NavigationBar!
    
    init(rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.rootViewController = rootViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        addChildViewController(rootViewController)
        view.addSubview(rootViewController.view)
        rootViewController.didMove(toParentViewController: self)
        
        navigationBar = NavigationBar(title: rootViewController.title)
        navigationBar.navigationController = self
        navigationBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(navigationBar)
        
        currentController = rootViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
        AppDelegate.shared.mainViewController.viewControllerForStatusBarAppearance = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: preferredNavigationBarHeight)
        currentController.view.frame = view.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayout()
    }
    
    @objc private func handleBack() {
        _ = popLastController()
        TestNavigationChildViewController.testCount -= 1
    }
    
    override var prefersStatusBarHidden: Bool {
        return isLandscape
    }
    
    // MARK: - Navigation bar appearance update
    
    weak var viewControllerForNavigationBarAppearance: UIViewController? {
        didSet {
            if oldValue != viewControllerForNavigationBarAppearance {
                updateNavigationBarAppearance(for: viewControllerForNavigationBarAppearance)
            }
        }
    }
    
    private(set) var isNavigationBarHidden = false {
        didSet {
            if isNavigationBarHidden != oldValue {
                navigationBar.alpha = isNavigationBarHidden ? 0 : 1
            }
        }
    }
    
    func updateNavigationBarAppearance(for viewController: UIViewController?) {
        guard viewController == viewControllerForNavigationBarAppearance else { return }
        if let viewController = viewController {
            isNavigationBarHidden = viewController.prefersNavigationBarHidden
        } else {
            isNavigationBarHidden = false
        }
    }
}

// MARK: - Navigation
extension NavigationController {
    
    func push(newController: UIViewController) {
        guard newController.parent != self else { return }
        
        newController.view.frame = CGRect(origin: CGPoint(x: view.frame.size.width, y: 0), size: view.frame.size)
        view.insertSubview(newController.view, aboveSubview: currentController.view)
        
        let oldController = currentController!
        addChildViewController(newController)
        currentController = newController
        
        navigationBar.preparePushing(newController)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: {
            oldController.view.frame = CGRect(origin: CGPoint(x: -0.6 * self.view.frame.size.width, y: 0), size: self.view.frame.size)
            oldController.view.alpha = 0.4
            newController.view.frame = self.view.bounds
            newController.setNeedsNavigationBarAppearanceUpdate()
        }) { (finished: Bool) in
            if newController.parent == self {
                newController.didMove(toParentViewController: self)
            }
            if oldController != self.currentController {
                oldController.view.removeFromSuperview()
            }
            self.navigationBar.finalizePush()
        }
        
        addShadowAnimation(toViewController: newController, isReversed: false)
        navigationBar.animatePushing()
    }

    func popLastController() -> UIViewController? {
        guard currentController != rootViewController else { return nil }
        
        let oldController = currentController!
        oldController.willMove(toParentViewController: nil)
        oldController.removeFromParentViewController()
        let newController = childViewControllers.last!
        currentController = newController
        
        newController.view.frame = CGRect(origin: CGPoint(x: -0.6 * view.frame.size.width, y: 0), size: view.frame.size)
        newController.view.alpha = 0.4
        view.insertSubview(newController.view, belowSubview: oldController.view)
        
        let backController = (childViewControllers.count > 1) ? childViewControllers[childViewControllers.count - 2] : nil
        navigationBar.preparePopping(backControllerAfterPop: backController)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: {
            oldController.view.frame = CGRect(origin: CGPoint(x: self.view.frame.size.width, y: 0), size: self.view.frame.size)
            newController.view.frame = self.view.bounds
            newController.view.alpha = 1
            newController.setNeedsNavigationBarAppearanceUpdate()
        }) { (finished: Bool) in
            if oldController != self.currentController {
                oldController.view.removeFromSuperview()
            }
            self.navigationBar.finalizePop(backControllerAfterPop: backController)
        }
        
        addShadowAnimation(toViewController: oldController, isReversed: true)
        navigationBar.animatePopping(backControllerAfterPop: backController)
        
        return oldController
    }
}

// MARK: - UI Constants
extension NavigationController {
    
    var preferredNavigationBarHeight: CGFloat {
        return isPortrait ? 44 + statusBarHeight : 32
    }
}
