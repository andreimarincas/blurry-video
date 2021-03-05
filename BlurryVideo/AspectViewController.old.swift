////
////  AspectViewController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/17/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//private var aspectViewControllerKVOContext = 0
//
//class AspectViewController: UIViewController {
//    
//    // Attempt load and test these asset keys before playing.
//    static let assetKeysRequiredToPlay = [
//        "playable",
//        "hasProtectedContent"
//    ]
//    
//    var largePlayerView: PlayerView!
//    var mediumPlayerView: PlayerView!
//    var smallPlayerView: PlayerView!
//    
//    var effectView: UIVisualEffectView!
//    var aspectBar: AspectBar!
//    let aspectBarHeight: CGFloat = 80
//    var currentAspect: AspectRatio?
//    
//    let player = AVPlayer()
//    
//    var asset: AVURLAsset? {
//        didSet {
//            guard let newAsset = asset else { return }
//            asynchronouslyLoadURLAsset(newAsset)
//        }
//    }
//    
//    private var playerItem: AVPlayerItem? = nil {
//        didSet {
//            player.replaceCurrentItem(with: self.playerItem)
//        }
//    }
//    
//    var currentTime: Double {
//        get {
//            return CMTimeGetSeconds(player.currentTime())
//        }
//        set {
//            let newTime = CMTimeMakeWithSeconds(newValue, 1)
//            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
//        }
//    }
//    
//    var duration: Double {
//        guard let currentItem = player.currentItem else { return 0.0 }
//        return CMTimeGetSeconds(currentItem.duration)
//    }
//    
//    override func viewDidLoad() {
//        logIN()
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.gray
//        largePlayerView = PlayerView()
//        largePlayerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
//        largePlayerView.backgroundColor = .clear
//        largePlayerView.playerLayer.backgroundColor = UIColor.clear.cgColor
//        largePlayerView.playerLayer.opacity = 0.1
//        view.addSubview(largePlayerView)
//        
//        mediumPlayerView = PlayerView()
//        mediumPlayerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
//        view.addSubview(mediumPlayerView)
//        
//        let blur = UIBlurEffect(style: .light)
//        effectView = UIVisualEffectView(effect: blur)
//        let vibrancy = UIVibrancyEffect(blurEffect: blur)
//        effectView.effect = vibrancy
//        mediumPlayerView.addSubview(effectView)
//        
//        smallPlayerView = PlayerView()
//        smallPlayerView.layer.borderWidth = 0.5
//        smallPlayerView.layer.borderColor = UIColor.black.cgColor
//        view.addSubview(smallPlayerView)
//        
//        aspectBar = AspectBar()
//        aspectBar.delegate = self
//        view.addSubview(aspectBar)
//        logOUT()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        logIN()
//        super.viewWillAppear(animated)
//        
//        addObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.duration), options: [.new, .initial], context: &aspectViewControllerKVOContext)
//        addObserver(self, forKeyPath: #keyPath(AspectViewController.player.rate), options: [.new, .initial], context: &aspectViewControllerKVOContext)
//        addObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.status), options: [.new, .initial], context: &aspectViewControllerKVOContext)
//        
////        largePlayerView.playerLayer.player = player
//        mediumPlayerView.playerLayer.player = player
//        smallPlayerView.playerLayer.player = player
//        
////        let movieURL = Bundle.main.url(forResource: "ElephantSeals", withExtension: "mov")!
//        let movieURL = Bundle.main.url(forResource: "IMG_0612", withExtension: "m4v")!
////        let movieURL = Bundle.main.url(forResource: "ed28834f-68b6-462d-8d17-2ec169ae16f8", withExtension: "m4v")!
//        
//        asset = AVURLAsset(url: movieURL, options: nil)
//        
//        updateLayout()
//        logOUT()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        logIN()
//        super.viewDidDisappear(animated)
//        
//        player.pause()
//        
//        removeObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.duration), context: &aspectViewControllerKVOContext)
//        removeObserver(self, forKeyPath: #keyPath(AspectViewController.player.rate), context: &aspectViewControllerKVOContext)
//        removeObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.status), context: &aspectViewControllerKVOContext)
//        
//        logOUT()
//    }
//    
//    private func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
//        logIN()
//        newAsset.loadValuesAsynchronously(forKeys: PlayerViewController.assetKeysRequiredToPlay) {
//            DispatchQueue.main.async {
//                guard newAsset == self.asset else { return }
//                for key in AspectViewController.assetKeysRequiredToPlay {
//                    var error: NSError?
//                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
//                        logError("Can't use this AVAsset because one of it's keys failed to load.")
//                        if let error = error {
//                            logError(error.localizedDescription)
//                        }
//                        return
//                    }
//                }
//                if !newAsset.isPlayable || newAsset.hasProtectedContent {
//                    logError("Can't use this AVAsset because it isn't playable or has protected content.")
//                    return
//                }
//                self.playerItem = AVPlayerItem(asset: newAsset)
//            }
//        }
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    private func playerFrame(for aspect: AspectRatio) -> CGRect {
////        let aspectSize = aspect.size
////        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
////        var playerSize: CGSize = .zero
////        if aspectSize.width >= aspectSize.height {
////            if isPortrait {
////                playerSize.width = view.frame.size.width
////            } else {
////                playerSize.width = view.frame.size.width / 2
////            }
////            playerSize.height = playerSize.width * aspectSize.height / aspectSize.width
////        } else {
////            if isPortrait {
////                playerSize.height = view.frame.size.height / 2
////            } else {
////                playerSize.height = view.frame.size.height
////            }
////            playerSize.width = playerSize.height * aspectSize.width / aspectSize.height
////        }
////        let center = CGPoint(x: view.frame.size.width / 2, y: (view.frame.size.height - aspectBarHeight) / 2)
////        let playerFrame = CGRect(x: center.x - playerSize.width / 2, y: center.y - playerSize.height / 2, width: playerSize.width, height: playerSize.height)
////        return playerFrame
//        
////        let availableFrame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - aspectBarHeight).insetBy(dx: 10, dy: 10)
//        
////        let availableFrame = self.availablePlayerFrame
//        
//        let top: CGFloat = (parent as? NavigationController)?.navigationBar.frame.size.height ?? 0
//        let availableFrame = CGRect(x: 0,
//                                    y: top,
//                                    width: view.frame.size.width,
//                                    height: view.frame.size.height - aspectBarHeight - top).insetBy(dx: 10, dy: 10)
//        let playerSize = availableFrame.sizeThatFitsInside(withAspect: aspect.value)
//        
////        var playerSize: CGSize = .zero
////        if aspect.size.width / aspect.size.height < availableFrame.size.width / availableFrame.size.height {
////            playerSize.height = availableFrame.size.height
////            playerSize.width = playerSize.height * aspect.size.width / aspect.size.height
////        } else {
////            playerSize.width = availableFrame.width
////            playerSize.height = playerSize.width * aspect.size.height / aspect.size.width
////        }
//        
////        let playerCenter = CGPoint(x: availableFrame.origin.x + availableFrame.size.width / 2, y: availableFrame.origin.y + availableFrame.size.height / 2)
////        let playerFrame = CGRect(x: playerCenter.x - playerSize.width / 2, y: playerCenter.y - playerSize.height / 2, width: playerSize.width, height: playerSize.height)
////        return playerFrame
//        
//        return CGRect(center: availableFrame.frameCenter, size: playerSize)
//    }
//    
////    var availablePlayerFrame: CGRect {
////        let top: CGFloat = (parent as? NavigationController)?.navigationBar.frame.size.height ?? 0
////        return CGRect(x: 0, y: top, width: view.frame.size.width, height: view.frame.size.height - aspectBarHeight).insetBy(dx: 10, dy: 10)
////    }
//    
//    func updateLayout() {
//        largePlayerView.frame = view.bounds
////        effectView.frame = view.bounds
//        
//        var playerFrame: CGRect!
//        if let aspect = currentAspect {
//            playerFrame = self.playerFrame(for: aspect)
//        } else {
//            playerFrame = view.bounds
//        }
//        mediumPlayerView.frame = playerFrame
//        smallPlayerView.frame = playerFrame
//        
////        print("video rect: \(smallPlayerView.playerLayer.videoRect)")
////        print("bounds: \(view.bounds)")
////        print("presentationSize: \(playerItem?.presentationSize ?? .zero)")
////        print("presentationSize: \(playerItem?.si ?? .zero)")
//        
//        effectView.frame = mediumPlayerView.bounds
//        aspectBar.frame = CGRect(x: 0, y: view.frame.size.height - aspectBarHeight, width: view.frame.size.width, height: aspectBarHeight)
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}
//
//extension AspectViewController: AspectBarDelegate {
//    
//    func aspectBar(_ bar: AspectBar, didChangeAspect aspect: AspectRatio) {
//        logIN()
//        currentAspect = aspect
//        updateLayout()
//        logOUT()
//    }
//}
//
//// MARK: - KVO Observation
//extension AspectViewController {
//    
//    // Update our UI when player or `player.currentItem` changes.
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        guard context == &aspectViewControllerKVOContext else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        if keyPath == #keyPath(AspectViewController.player.rate) {
//            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
//            logDebug("rate: \(newRate)")
//            if newRate != 1.0 {
//                // Not playing forward, so play.
//                if currentTime == duration {
//                    // At end, so got back to begining.
//                    currentTime = 0.0
//                }
//                player.play()
//            }
//        }
//        
//        /*if keyPath == #keyPath(AspectViewController.player.currentItem.duration) {
//            // Update timeSlider and enable/disable controls when duration > 0.0
//            // Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when `player.currentItem` is nil.
////            let newDuration: CMTime
////            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
////                newDuration = newDurationAsValue.timeValue
////            }
////            else {
////                newDuration = kCMTimeZero
////            }
////            
////            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
////            tapGr.isEnabled = hasValidDuration
////            
////            let newDurationSeconds = hasValidDuration ? Double(CMTimeGetSeconds(newDuration)) : 0.0
////            let currentTime = hasValidDuration ? Double(CMTimeGetSeconds(player.currentTime())) : 0.0
////            playerSlider.maximumValue = CGFloat(newDurationSeconds)
////            playerSlider.progress = CGFloat(currentTime)
//            
//        } else if keyPath == #keyPath(AspectViewController.player.rate) {
//            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
//            logDebug("rate: \(newRate)")
//            
//            if newRate != 1.0 {
//                // Not playing forward, so play.
//                if currentTime == duration {
//                    // At end, so got back to begining.
//                    currentTime = 0.0
//                }
//                player.play()
//            
//        } else if keyPath == #keyPath(AspectViewController.player.currentItem.status) {
////            // Display an error if status becomes `.Failed`.
////            
////            /*
////             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
////             `player.currentItem` is nil.
////             */
////            let newStatus: AVPlayerItemStatus
////            
////            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
////                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
////            } else {
////                newStatus = .unknown
////            }
////            if newStatus == .failed {
////                if let error = player.currentItem?.error {
////                    logError(error.localizedDescription)
////                }
////            }
//        }*/
//    }
//    
////    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
////    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
////        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
////            "duration":     [#keyPath(AspectViewController.player.currentItem.duration)],
////            "rate":         [#keyPath(AspectViewController.player.rate)]
////        ]
////        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
////    }
//}
