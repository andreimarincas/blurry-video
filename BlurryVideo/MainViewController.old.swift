////
////  MainViewController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/16/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//
//class MainViewController: UIViewController {
//    
//    var playerViewController: PlayerViewController!
//    var playerSlider: TimeSlider!
//    let statusBarHeight: CGFloat = 20
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = ColorPalette.mineShaft
//        
//        playerViewController = PlayerViewController()
//        playerViewController.loadViewIfNeeded()
//        addChildViewController(playerViewController)
//        view.addSubview(playerViewController.view)
//        playerViewController.didMove(toParentViewController: self)
//        
////        let label = ArrowLabel()
////        label.text = "12:56"
////        view.addSubview(label)
////        label.frame = CGRect(x: 20, y: 500, width: 100, height: 50)
//        
//        
//        let button1 = AspectButton(aspect: .fullscreen)
////        button1.backgroundColor = UIColor.black
//        view.addSubview(button1)
//        button1.frame = CGRect(x: 10, y: 500, width: 70, height: 70)
//        
//        let button2 = AspectButton(aspect: .fullscreenPortrait)
////        button2.backgroundColor = UIColor.black
//        view.addSubview(button2)
//        button2.frame = CGRect(x: 90, y: 500, width: 70, height: 70)
//        
//        let button3 = AspectButton(aspect: .widescreen)
////        button3.backgroundColor = UIColor.black
//        view.addSubview(button3)
//        button3.frame = CGRect(x: 170, y: 500, width: 70, height: 70)
//        
//        let button4 = AspectButton(aspect: .widescreenPortrait)
////        button4.backgroundColor = UIColor.black
//        view.addSubview(button4)
//        button4.frame = CGRect(x: 250, y: 500, width: 70, height: 70)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateLayout()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        playerViewController.updateLayout()
//    }
//    
//    func updateLayout() {
//        playerViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: statusBarHeight), size: playerViewController.preferredSize)
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//}
