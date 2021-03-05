////
////  NavigationController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/18/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//
//class NavigationController: MainViewController {
//    
//    enum SlideDirection {
//        case leftToRight
//        case rightToLeft
//    }
//    
//    // The rootViewController will never get removed from childViewControllers.
//    // However, its view will gets removed from the view hierarchy on cycling to other view-controllers.
//    fileprivate var rootViewController: UIViewController!
//    
//    private var currentController: UIViewController!
//    
//    var navigationBar: NavigationBar!
//    var lastSelectedButton: NavigationBar.Button = .library
//    
//    let assetManager = BlurryAssetManager.shared
//    
//    init(rootViewController: UIViewController) {
//        super.init(nibName: nil, bundle: nil)
//        self.rootViewController = rootViewController
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationBar = NavigationBar(frame: .zero)
//        navigationBar.delegate = self
//        for i in 1..<navigationBar.titleButtons.count {
//            navigationBar.titleButtons[i].isEnabled = false
//        }
//        view.addSubview(navigationBar)
//        
//        currentController = rootViewController
//        addChildViewController(currentController)
//        view.insertSubview(currentController.view, belowSubview: navigationBar)
//        currentController.didMove(toParentViewController: self)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        addObserver(self, forKeyPath: KeyPath.originalAspect, options: [.new, .initial], context: &navigationControllerKVOContext)
//        addObserver(self, forKeyPath: KeyPath.currentAspect, options: [.new, .initial], context: &navigationControllerKVOContext)
//        
//        updateLayout()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        removeObserver(self, forKeyPath: KeyPath.originalAspect, context: &navigationControllerKVOContext)
//        removeObserver(self, forKeyPath: KeyPath.currentAspect, context: &navigationControllerKVOContext)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    private func updateLayout() {
//        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: navigationBarHeight)
//        currentController.view.frame = view.bounds
//    }
//    
//    fileprivate func cycleToViewController(_ newController: UIViewController, direction: SlideDirection) {
//        guard newController != currentController else { return }
//        
//        // Calculate the `from` and `to` frames for transition
//        var fromFrame: CGRect
//        var toFrame: CGRect
//        if direction == .rightToLeft {
//            fromFrame = CGRect(origin: CGPoint(x: view.frame.size.width, y: 0), size: view.frame.size)
//            toFrame = CGRect(origin: CGPoint(x: -view.frame.size.width, y: 0), size: view.frame.size)
//        } else {
//            fromFrame = CGRect(origin: CGPoint(x: -view.frame.size.width, y: 0), size: view.frame.size)
//            toFrame = CGRect(origin: CGPoint(x: view.frame.size.width, y: 0), size: view.frame.size)
//        }
//        
//        newController.view.frame = fromFrame
//        newController.view.alpha = 0
//        view.insertSubview(newController.view, belowSubview: navigationBar)
//        
//        let oldController = currentController!
//        currentController = newController
//        
//        // Only the root view-controller remains in the child view-controllers hierarchy, others get removed (and deallocated).
//        if oldController != rootViewController {
//            oldController.willMove(toParentViewController: nil)
//        }
//        if newController != rootViewController {
//            addChildViewController(newController)
//        }
//        
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: 1.8,
//                       initialSpringVelocity: 1,
//                       options: [.curveEaseOut, .beginFromCurrentState],
//                       animations: {
//                        oldController.view.frame = toFrame
//                        newController.view.frame = self.view.bounds
//                        newController.view.alpha = 1 },
//                       completion: { finished in
//                        // Finish view-controller transition
//                        if oldController != self.currentController {
//                            oldController.view.removeFromSuperview()
//                            if oldController != self.rootViewController {
//                                oldController.removeFromParentViewController()
//                            }
//                        }
//                        if newController != self.rootViewController {
//                            newController.didMove(toParentViewController: self)
//                        }
//        })
//    }
//}
//
//extension NavigationController: NavigationBarDelegate {
//    
//    func navigationBar(_ navigationBar: NavigationBar, didSelectButton selectedButton: NavigationBar.Button) {
//        logDebug("selected button: \(selectedButton.rawValue)")
//        let direction: SlideDirection = (selectedButton.rawValue > lastSelectedButton.rawValue) ? .rightToLeft : .leftToRight
//        switch selectedButton {
//        case .library:
//            cycleToViewController(rootViewController, direction: direction)
//            break
//        case .aspect:
//            let aspectVC = AspectViewController(asset: assetManager.currentAsset!)
//            cycleToViewController(aspectVC, direction: direction)
//            break
//        case .blur:
//            // TODO: BlurViewController
//            let newVC = UIViewController()
//            newVC.view.backgroundColor = .green
//            cycleToViewController(newVC, direction: direction)
//            break
//        }
//        lastSelectedButton = selectedButton
//    }
//}
//
//// MARK: - UI Constants
//extension NavigationController {
//    
//    var navigationBarHeight: CGFloat {
//        return statusBarHeight + 44
//    }
//}
//
//// MARK: - KVO Observation
//
//private var navigationControllerKVOContext = 0
//
//private struct KeyPath {
//    
//    static let originalAspect = #keyPath(NavigationController.assetManager.currentAsset.originalAspect)
//    static let currentAspect = #keyPath(NavigationController.assetManager.currentAsset.currentAspect)
//}
//
//extension NavigationController {
//    
//    // Update tabs availability when current asset or current asset's aspect changes.
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        guard context == &navigationControllerKVOContext else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        // Enable/disable Aspect and Blurring tabs
//        
//        if keyPath == KeyPath.originalAspect {
//            let hasOriginalAspect = (assetManager.currentAsset?.originalAspect != nil)
//            navigationBar.enableTitle(button: .aspect, isEnabled: hasOriginalAspect)
//            
//        } else if keyPath == KeyPath.currentAspect {
//            let hasCurrentAspect = (assetManager.currentAsset?.currentAspect != nil)
//            navigationBar.enableTitle(button: .blur, isEnabled: hasCurrentAspect)
//        }
//    }
//}
