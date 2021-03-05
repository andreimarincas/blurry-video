////
////  LibraryPlayerViewController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/18/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//private var libraryPlayerViewControllerKVOContext = 0
//
//private let PLAYER_SLIDER_HEIGHT: CGFloat = 31
//private let PLAYER_VIEW_MARGIN: CGFloat = 20
//private let PLAYER_SLIDER_MARGIN_TOP: CGFloat = 10
//private let BOTTOM_TOOLBAR_HEIGHT: CGFloat = 44
//
//class LibraryPlayerViewController: UIViewController {
//    
//    // Attempt load and test these asset keys before playing.
//    static let assetKeysRequiredToPlay = [
//        "playable",
//        "hasProtectedContent"
//    ]
//    
//    var playerView: PlayerView!
//    var playerSlider: CustomSlider!
//    var bottomToolbar: LibraryPlayerToolbar!
//    
//    let player = AVPlayer()
//    
//    var tapGr: UITapGestureRecognizer!
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
//    private var timeObserverToken: Any?
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
//        view.backgroundColor = UIColor.white
//        
//        playerView = PlayerView()
//        playerView.backgroundColor = .clear
//        playerView.playerLayer.backgroundColor = UIColor.clear.cgColor
//        view.addSubview(playerView)
//        
//        playerSlider = CustomSlider()
//        playerSlider.layer.cornerRadius = PLAYER_SLIDER_HEIGHT / 2
//        playerSlider.layer.masksToBounds = true
//        view.addSubview(playerSlider)
//        
//        bottomToolbar = LibraryPlayerToolbar()
//        view.addSubview(bottomToolbar)
//        
//        tapGr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        playerView.addGestureRecognizer(tapGr)
//        
//        logOUT()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        logIN()
//        super.viewWillAppear(animated)
//        
//        addObserver(self, forKeyPath: #keyPath(LibraryPlayerViewController.player.currentItem.duration), options: [.new, .initial], context: &libraryPlayerViewControllerKVOContext)
//        addObserver(self, forKeyPath: #keyPath(LibraryPlayerViewController.player.rate), options: [.new, .initial], context: &libraryPlayerViewControllerKVOContext)
//        addObserver(self, forKeyPath: #keyPath(LibraryPlayerViewController.player.currentItem.status), options: [.new, .initial], context: &libraryPlayerViewControllerKVOContext)
//        
//        playerView.player = player
//        
//        //        let movieURL = Bundle.main.url(forResource: "ElephantSeals", withExtension: "mov")!
//        let movieURL = Bundle.main.url(forResource: "IMG_0612", withExtension: "m4v")!
//        //        let movieURL = Bundle.main.url(forResource: "ed28834f-68b6-462d-8d17-2ec169ae16f8", withExtension: "m4v")!
//        
//        asset = AVURLAsset(url: movieURL, options: nil)
//        
//        // Make sure we don't have a strong reference cycle by only capturing self as weak.
//        let interval = CMTimeMake(1, 60)
//        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
//            guard let weakSelf = self else { return }
//            let timeElapsed = Double(CMTimeGetSeconds(time))
//            weakSelf.playerSlider.setProgress(CGFloat(timeElapsed), animated: true)
//        }
//        
//        updateLayout()
//        
//        logOUT()
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        logIN()
//        super.viewDidDisappear(animated)
//        
//        if let timeObserverToken = timeObserverToken {
//            player.removeTimeObserver(timeObserverToken)
//            self.timeObserverToken = nil
//        }
//        
//        player.pause()
//        
//        removeObserver(self, forKeyPath: #keyPath(LibraryPlayerViewController.player.currentItem.duration), context: &libraryPlayerViewControllerKVOContext)
//        removeObserver(self, forKeyPath: #keyPath(LibraryPlayerViewController.player.rate), context: &libraryPlayerViewControllerKVOContext)
//        removeObserver(self, forKeyPath: #keyPath(LibraryPlayerViewController.player.currentItem.status), context: &libraryPlayerViewControllerKVOContext)
//        
//        logOUT()
//    }
//    
//    private func asynchronouslyLoadURLAsset(_ newAsset: AVAsset) {
//        logIN()
//        newAsset.loadValuesAsynchronously(forKeys: LibraryPlayerViewController.assetKeysRequiredToPlay) {
//            DispatchQueue.main.async {
//                guard newAsset == self.asset else { return }
//                for key in LibraryPlayerViewController.assetKeysRequiredToPlay {
//                    var error: NSError?
//                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
//                        logError("Can't use this AVAsset because one of it's keys failed to load")
//                        if let error = error {
//                            logError(error.localizedDescription)
//                        }
//                        return
//                    }
//                }
//                if !newAsset.isPlayable || newAsset.hasProtectedContent {
//                    logError("Can't use this AVAsset because it isn't playable or has protected content")
//                    return
//                }
//                self.playerItem = AVPlayerItem(asset: newAsset)
//            }
//        }
//    }
//    
//    @objc private func handleTap() {
//        logIN()
//        if player.rate != 1.0 {
//            // Not playing forward, so play.
//            //            if currentTime == duration {
//            //                // At end, so got back to begining.
//            //                currentTime = 0.0
//            //            }
//            player.play()
//        } else {
//            // Playing, so pause.
//            player.pause()
//        }
//        logOUT()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout() {
////        playerView.frame = view.bounds
//        playerView.frame = view.bounds.insetBy(dx: -1, dy: -1) // expand slightly to avoid blank margins
////        playerSlider.frame = CGRect(x: playerViewMargin,
////                                    y: playerViewContainer.frame.size.height + playerSliderMarginTop,
////                                    width: playerView.frame.size.width,
////                                    height: playerSliderHeight)
//        bottomToolbar.frame = CGRect(x: 0, y: view.frame.size.height - BOTTOM_TOOLBAR_HEIGHT, width: view.frame.size.width, height: BOTTOM_TOOLBAR_HEIGHT)
//    }
//}
//
//// MARK: - KVO Observation
//extension LibraryPlayerViewController {
//    
//    // Update our UI when player or `player.currentItem` changes.
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        guard context == &libraryPlayerViewControllerKVOContext else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        
//        if keyPath == #keyPath(LibraryPlayerViewController.player.currentItem.duration) {
//            // Update timeSlider and enable/disable controls when duration > 0.0
//            // Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when `player.currentItem` is nil.
//            let newDuration: CMTime
//            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
//                newDuration = newDurationAsValue.timeValue
//            }
//            else {
//                newDuration = kCMTimeZero
//            }
//            
//            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
//            tapGr.isEnabled = hasValidDuration
//            
//            let newDurationSeconds = hasValidDuration ? Double(CMTimeGetSeconds(newDuration)) : 0.0
//            let currentTime = hasValidDuration ? Double(CMTimeGetSeconds(player.currentTime())) : 0.0
//            playerSlider.maximumValue = CGFloat(newDurationSeconds)
//            playerSlider.progress = CGFloat(currentTime)
//            
//        } else if keyPath == #keyPath(LibraryPlayerViewController.player.rate) {
//            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
//            logDebug("rate: \(newRate)")
//            
//        } else if keyPath == #keyPath(LibraryPlayerViewController.player.currentItem.status) {
//            // Display an error if status becomes `.Failed`.
//            
//            /*
//             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
//             `player.currentItem` is nil.
//             */
//            let newStatus: AVPlayerItemStatus
//            
//            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
//                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
//            } else {
//                newStatus = .unknown
//            }
//            if newStatus == .failed {
//                if let error = player.currentItem?.error {
//                    logError(error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
//    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
//        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
//            "duration":     [#keyPath(LibraryPlayerViewController.player.currentItem.duration)],
//            "rate":         [#keyPath(LibraryPlayerViewController.player.rate)]
//        ]
//        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
//    }
//}
