////
////  LibraryPlayerViewController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/19/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import AVFoundation
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
//    var timeSlider: TimeSlider!
//    var bottomToolbar: LibraryPlayerToolbar!
//    
//    let player = AVPlayer()
//    
//    var tapGr: UITapGestureRecognizer!
//    
//    var asset: AVURLAsset? {
//        didSet {
//            guard let newAsset = asset else { return }
//            loadURLAssetAsync(newAsset)
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
////            /*!
////             @typedef	CMTimeValue
////             @abstract	Numerator of rational CMTime.
////             */
////            public typealias CMTimeValue = Int64
////
////            /*!
////             @typedef	CMTimeScale
////             @abstract	Denominator of rational CMTime.
////             @discussion	Timescales must be positive.
////             Note: kCMTimeMaxTimescale is NOT a good choice of timescale for movie files.
////             (Recommended timescales for movie files range from 600 to 90000.)
////             */
////            public typealias CMTimeScale = Int32
////            public var kCMTimeMaxTimescale: Int { get }
//
//
////            public var value: CMTimeValue /*! @field value The value of the CMTime. value/timescale = seconds. */
////
////            /*! @field value The value of the CMTime. value/timescale = seconds. */
////            public var timescale: CMTimeScale /*! @field timescale The timescale of the CMTime. value/timescale = seconds.  */
//            
////            let newTime = CMTimeMakeWithSeconds(newValue, 1)
//            let newTime = CMTimeMakeWithSeconds(newValue, 600)
//            stopPlayingAndSeekSmoothlyToTime(newChaseTime: newTime)
//        }
//    }
//    
//    var duration: Double {
//        guard let currentItem = player.currentItem else { return 0.0 }
//        return CMTimeGetSeconds(currentItem.duration)
//    }
//    
//    var isFullscreen = false
//    
////    var wasPlayingBeforeTracking = false
//    var isTracking = false /*{
//        didSet {
//            if isTracking != oldValue {
//                if isTracking {
//                    if !isSeekInProgress {
//                        wasPlayingBeforeTracking = player.isPlaying
//                        player.pause()
//                    }
//                } else {
//                    logDebug("isTracking: Attempt to resume playing...")
//                    if wasPlayingBeforeTracking && !isSeekInProgress {
//                        // Resume playing if not at the end.
//                        player.play()
//                        logDebug("DID!")
//                    } else {
//                        logDebug("DID NOT! wasPlayingBeforeTracking = \(wasPlayingBeforeTracking), isSeekInProgress = \(isSeekInProgress)")
//                    }
//                }
//            }
//        }
//    }*/
//    
//    var isSeekInProgress = false
//    var chaseTime = kCMTimeZero
//    var playerCurrentItemStatus: AVPlayerItemStatus = .unknown // KVO player.currentItem.status
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
//        timeSlider = TimeSlider()
//        timeSlider.minimumTrackTintColor = .red
//        timeSlider.maximumTrackTintColor = .lightGray
//        timeSlider.setThumbImage(UIImage(named: "thumb")!, for: .normal)
//        timeSlider.setThumbImage(UIImage(named: "thumb")!, for: .highlighted)
//        timeSlider.addTarget(self, action: #selector(timeSliderDidChange(_:)), for: .valueChanged)
//        timeSlider.delegate = self
//        view.addSubview(timeSlider)
//        
//        bottomToolbar = LibraryPlayerToolbar()
//        bottomToolbar.playPauseButton.addTarget(self, action: #selector(playPauseButtonWasPressed(_:)), for: .touchUpInside)
//        view.addSubview(bottomToolbar)
//        
//        tapGr = UITapGestureRecognizer(target: self, action: #selector(playerWasTouched))
//        playerView.addGestureRecognizer(tapGr)
//        
//        logOUT()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        logIN()
//        super.viewWillAppear(animated)
//        
//        addObserver(self, forKeyPath: KeyPath.duration, options: [.new, .initial], context: &libraryPlayerKVOContext)
//        addObserver(self, forKeyPath: KeyPath.rate, options: [.new, .initial], context: &libraryPlayerKVOContext)
//        addObserver(self, forKeyPath: KeyPath.status, options: [.new, .initial], context: &libraryPlayerKVOContext)
//        
//        playerView.player = player
//        
//        let interval = CMTimeMake(1, 600)
////        let interval = CMTimeMake(1, 1)
//        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
//            guard let weakSelf = self else { return }
//            let timeElapsed = Float(CMTimeGetSeconds(time))
//            if !weakSelf.isTracking && !weakSelf.isSeekInProgress {
//                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
//                    weakSelf.timeSlider.setValue(timeElapsed, animated: true)
//                }, completion: nil)
//            }
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
//        removeObserver(self, forKeyPath: KeyPath.duration, context: &libraryPlayerKVOContext)
//        removeObserver(self, forKeyPath: KeyPath.rate, context: &libraryPlayerKVOContext)
//        removeObserver(self, forKeyPath: KeyPath.status, context: &libraryPlayerKVOContext)
//        
//        logOUT()
//    }
//    
//    private func loadURLAssetAsync(_ asset: AVAsset) {
//        asset.loadValuesAsynchronously(forKeys: LibraryPlayerViewController.assetKeysRequiredToPlay) {
//            DispatchQueue.main.async {
//                guard asset == self.asset else { return }
//                for key in LibraryPlayerViewController.assetKeysRequiredToPlay {
//                    var error: NSError?
//                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
//                        logError("Can't use this AVAsset because one of it's keys failed to load.")
//                        if let error = error {
//                            logError(error.localizedDescription)
//                        }
//                        return
//                    }
//                }
//                if !asset.isPlayable || asset.hasProtectedContent {
//                    logError("Can't use this AVAsset because it isn't playable or has protected content")
//                    return
//                }
//                self.playerItem = AVPlayerItem(asset: asset)
//            }
//        }
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//    
//    func updateLayout() {
//        playerView.frame = view.bounds.insetBy(dx: -1, dy: -1) // Expand slightly to avoid blank margins.
//        timeSlider.frame = CGRect(x: playerSliderMargin,
//                                  y: bottomToolbar.frame.origin.y - playerSliderHeight - playerSliderMargin,
//                                  width: playerView.frame.size.width - 2 * playerSliderMargin,
//                                  height: playerSliderHeight)
//        bottomToolbar.frame = CGRect(x: 0,
//                                     y: view.frame.size.height - bottomToolbarHeight,
//                                     width: view.frame.size.width,
//                                     height: bottomToolbarHeight)
//    }
//}
//
//// MARK: - Actions
//extension LibraryPlayerViewController {
//    
//    @objc func playerWasTouched() {
//        let navigationBar: NavigationBar? = (parent?.parent as? NavigationController)?.navigationBar
//        isFullscreen = !isFullscreen
//        let toAlpha: CGFloat = isFullscreen ? 0 : 1
//        UIView.animate(withDuration: 0.3, delay: 0,
//                       usingSpringWithDamping: 1, initialSpringVelocity: 1,
//                       options: [.curveEaseOut, .beginFromCurrentState],
//                       animations: {
//                        navigationBar?.alpha = toAlpha
//                        self.bottomToolbar.alpha = toAlpha
//                        self.timeSlider.alpha = toAlpha
//                        self.playerView.backgroundColor = self.isFullscreen ? .black : .clear
//                        AppDelegate.shared.rootViewController.viewControllerForStatusBarAppearance = self
//        }, completion: nil)
//    }
//    
//    @objc func playPauseButtonWasPressed(_ sender: UIButton) {
//        if !player.isPlaying {
//            if currentTime == duration {
//                timeSlider.value = 0
//                currentTime = 0
//            }
//            player.play()
//        } else {
//            player.pause()
//        }
//    }
//    
//    @objc func timeSliderDidChange(_ sender: UISlider) {
//        currentTime = Double(sender.value)
//    }
//}
//
//extension LibraryPlayerViewController: TimeSliderDelegate {
//    
//    func slider(_ slider: TimeSlider, didChangeTracking isTracking: Bool) {
//        self.isTracking = isTracking
//    }
//}
//
//// MARK: - KVO Observation
//
//private var libraryPlayerKVOContext = 0
//
//private struct KeyPath {
//    
//    static let duration = #keyPath(LibraryPlayerViewController.player.currentItem.duration)
//    static let rate = #keyPath(LibraryPlayerViewController.player.rate)
//    static let status = #keyPath(LibraryPlayerViewController.player.currentItem.status)
//}
//
//extension LibraryPlayerViewController {
//    
//    // Update our UI when player or `player.currentItem` changes.
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        guard context == &libraryPlayerKVOContext else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        if keyPath == KeyPath.duration {
//            // Update timeSlider and enable/disable controls when duration > 0.0
//            // Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when `player.currentItem` is nil.
//            let newDuration: CMTime
//            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
//                newDuration = newDurationAsValue.timeValue
//            } else {
//                newDuration = kCMTimeZero
//            }
//            
//            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
//            bottomToolbar.playPauseButton.isEnabled = hasValidDuration
//            timeSlider.isEnabled = hasValidDuration
//            
//            let newDurationSeconds = hasValidDuration ? Float(CMTimeGetSeconds(newDuration)) : 0.0
//            let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
//            timeSlider.maximumValue = newDurationSeconds
//            timeSlider.value = currentTime
//            
//        } else if keyPath == KeyPath.rate {
//            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
//            logDebug("rate: \(newRate)")
//            
//            // Update `playPauseButton` image.
//            let buttonImageName = newRate == 1.0 ? "pause-btn" : "play-btn"
//            let buttonImage = UIImage(named: buttonImageName)
//            bottomToolbar.playPauseButton.setImage(buttonImage, for: .normal)
//            
//        } else if keyPath == KeyPath.status {
//            // Display an error if status becomes `.Failed`.
//            
//            /*
//             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
//             `player.currentItem` is nil.
//             */
//            let newStatus: AVPlayerItemStatus
//            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
//                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
//            } else {
//                newStatus = .unknown
//            }
//            playerCurrentItemStatus = newStatus
//            if newStatus == .failed {
//                if let error = player.currentItem?.error {
//                    logError(error.localizedDescription)
//                }
//                // TODO: Handle/display error with message
//            }
//            
//        }
//    }
//    
//    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
//    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
//        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
//            "duration" : [KeyPath.duration],
//            "rate" : [KeyPath.rate]
//        ]
//        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
//    }
//}
//
//// MARK: - Smooth Video Scrubbing
//
//extension LibraryPlayerViewController {
//    
//    func stopPlayingAndSeekSmoothlyToTime(newChaseTime: CMTime) {
////        if !isSeekInProgress {
////            wasPlayingBeforeTracking = player.isPlaying
////        }
//        player.pause()
//        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
//            chaseTime = newChaseTime
//            if !isSeekInProgress {
//                trySeekToChaseTime()
//            }
//        }
//    }
//    
//    func trySeekToChaseTime() {
//        if playerCurrentItemStatus == .unknown {
//            // Wait until item becomes ready (KVO player.currentItem.status)
//        } else if playerCurrentItemStatus == .readyToPlay {
//            actuallySeekToTime()
//        }
//    }
//    
//    func actuallySeekToTime() {
//        isSeekInProgress = true
//        let seekTimeInProgress = chaseTime
//        player.seek(to: seekTimeInProgress, toleranceBefore: kCMTimeZero,
//                    toleranceAfter: kCMTimeZero, completionHandler:
//            { [weak self] (isFinished: Bool) -> Void in
//                guard let weakSelf = self else { return }
//                if CMTimeCompare(seekTimeInProgress, weakSelf.chaseTime) == 0 {
//                    weakSelf.isSeekInProgress = false
////                    logDebug("actuallySeekToTime: Attempt to resume playing...")
////                    if !weakSelf.isTracking && weakSelf.wasPlayingBeforeTracking {
////                        weakSelf.player.play()
////                        logDebug("DID.")
////                    } else {
////                        logDebug("DID NOT. isTracking=\(weakSelf.isTracking), wasPlayingBeforeTracking=\(weakSelf.wasPlayingBeforeTracking)")
////                    }
//                } else {
//                    weakSelf.trySeekToChaseTime()
//                }
//        })
//    }
//}
//
//// MARK: - UI Constants
//
//private let playerSliderHeight: CGFloat = 31
//private let playerSliderMargin: CGFloat = 22
//
//extension LibraryPlayerViewController {
//    
//    var bottomToolbarHeight: CGFloat {
//        return 44
//    }
//}
//
//// MARK: - Status Bar Appearance
//extension LibraryPlayerViewController {
//    
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .fade
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return isFullscreen
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
//}
