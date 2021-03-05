//
//  TestNavigationChildViewController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/25/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class TestNavigationChildViewController: UIViewController {
    
    var pushButton: UIButton!
    var popButton: UIButton!
    
    static var testCount = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        TestNavigationChildViewController.testCount += 1
        title = "Child \(TestNavigationChildViewController.testCount)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pushButton = UIButton(type: .custom)
        pushButton.setTitle("PUSH", for: .normal)
        pushButton.titleLabel?.font = UIFont.applicationFont(ofSize: 15)
        pushButton.titleLabel?.textAlignment = .center
        pushButton.setTitleColor(UIColor(hex: 0x0071ff), for: .normal)
        pushButton.setTitleColor(UIColor(hex: 0x0071ff).withAlphaComponent(0.3), for: .highlighted)
        pushButton.addTarget(self, action: #selector(pushNext), for: .touchUpInside)
        view.addSubview(pushButton)
        
        popButton = UIButton(type: .custom)
        popButton.setTitle("POP", for: .normal)
        popButton.titleLabel?.font = UIFont.applicationFont(ofSize: 15)
        popButton.titleLabel?.textAlignment = .center
        popButton.setTitleColor(UIColor(hex: 0x0071ff), for: .normal)
        popButton.setTitleColor(UIColor(hex: 0x0071ff).withAlphaComponent(0.3), for: .highlighted)
        popButton.setTitleColor(UIColor(hex: 0x0071ff).withAlphaComponent(0.3), for: .disabled)
        popButton.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        view.addSubview(popButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logDebug("view will appear: " + title!)
        super.viewWillAppear(animated)
        updateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logDebug("view did appear: " + title!)
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logDebug("view will disappear" + title!)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        logDebug("view did disappear" + title!)
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        let buttonSize = CGSize(width: 200, height: 100)
        pushButton.frame = CGRect(center: center, size: buttonSize).offsetBy(dx: 0, dy: -buttonSize.height / 2)
        popButton.frame = CGRect(center: center, size: buttonSize).offsetBy(dx: 0, dy: buttonSize.height / 2)
    }
    
    @objc func pushNext() {
        customNavigationController?.push(newController: TestNavigationChildViewController())
    }
    
    @objc func popToPrevious() {
        _ = customNavigationController?.popLastController()
        TestNavigationChildViewController.testCount -= 1
    }
}
