//
//  AppDelegate.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/15/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
//    var mainViewController: MainViewController {
//        return window!.rootViewController as! MainViewController
//    }
    
    private(set) var mainViewController: MainViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        logIN()
        
        let bounds = UIScreen.main.bounds
        let window = UIWindow(frame: bounds)
        window.backgroundColor = UIColor.black
        
//        let mainVC = MainViewController()
//        mainVC.view.frame = bounds
//        window.rootViewController = mainVC
        
//        let childVC = TestNavigationChildViewController()
//        childVC.loadViewIfNeeded()
//        childVC.popButton.isEnabled = false
//        let navController = NavigationController(rootViewController: childVC)
//        navController.view.frame = bounds
//        window.rootViewController = navController
        
//        let videoPickerVC = VideoPickerViewController()
//        let navigationController = NavigationController(rootViewController: videoPickerVC)
//        navigationController.view.frame = bounds
//        window.rootViewController = navigationController
        
//        let videoPickerVC = VideoPickerViewController()
//        mainViewController = NavigationController(rootViewController: videoPickerVC)
//        mainViewController.view.frame = bounds
//        window.rootViewController = mainViewController
        
//        let aspectVC = AspectViewController()
//        mainViewController = NavigationController(rootViewController: aspectVC)
//        mainViewController.view.frame = bounds
//        window.rootViewController = mainViewController
        
        mainViewController = MainViewController()
        mainViewController.view.frame = bounds
        window.rootViewController = mainViewController

        let videoPickerVC = VideoPickerViewController()
        let navigationController = NavigationController(rootViewController: videoPickerVC)
        navigationController.view.frame = mainViewController.view.bounds
        mainViewController.addChildViewController(navigationController)
        mainViewController.view.addSubview(navigationController.view)
        navigationController.didMove(toParentViewController: mainViewController)
        
//        let aspectVC = AspectViewController()
//        let navigationController = NavigationController(rootViewController: aspectVC)
//        navigationController.view.frame = mainViewController.view.bounds
//        mainViewController.addChildViewController(navigationController)
//        mainViewController.view.addSubview(navigationController.view)
//        navigationController.didMove(toParentViewController: mainViewController)
        
//        let aspectVC = AspectViewController()
//        aspectVC.view.frame = mainViewController.view.bounds
//        mainViewController.addChildViewController(aspectVC)
//        mainViewController.view.addSubview(aspectVC.view)
//        aspectVC.didMove(toParentViewController: mainViewController)
        
        window.makeKeyAndVisible()
        self.window = window
        
        logOUT()
        return true
    }
}
