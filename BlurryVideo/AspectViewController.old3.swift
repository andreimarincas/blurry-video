////
////  AspectViewController.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/22/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class AspectViewController: UIViewController {
//
//    var blurryAsset: BlurryAsset!
//    var aspectBar: AspectBar!
//
//    var currentAspect: Aspect! {
//        didSet {
//            blurryAsset.currentAspect = currentAspect
//        }
//    }
//
//    // Attempt load and test these asset keys before playing.
//    let assetKeysRequiredToPlay = [
//        "playable",
//        "hasProtectedContent"
//    ]
//
//    var playerView: PlayerView!
//    var blurryPlayerView: BlurryPlayerView!
//
//    let player = AVPlayer()
//
//    var urlAsset: AVURLAsset? {
//        didSet {
//            guard let newAsset = urlAsset else { return }
//            loadValuesAsync(forAsset: newAsset)
//        }
//    }
//
//    var playerItem: AVPlayerItem? = nil {
//        didSet {
//            player.replaceCurrentItem(with: playerItem)
//        }
//    }
//
//    var userPaused = false
//
//    // `blurryAsset`: An asset with valid `urlAsset` and `originalAspect`.
//    init(asset: BlurryAsset) {
//        super.init(nibName: nil, bundle: nil)
//        blurryAsset = asset
//        if let currentAspect = asset.currentAspect {
//            self.currentAspect = currentAspect
//        } else {
//            self.currentAspect = asset.originalAspect!
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        logIN()
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//
//        blurryPlayerView = BlurryPlayerView()
//        blurryPlayerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
//        view.addSubview(blurryPlayerView)
//
//        playerView = PlayerView()
//        playerView.backgroundColor = .clear
//        playerView.layer.backgroundColor = UIColor.clear.cgColor
//        playerView.layer.borderWidth = 0.5
//        playerView.layer.borderColor = UIColor.black.cgColor
//        view.addSubview(playerView)
//
//        aspectBar = AspectBar()
//        if let aspect = currentAspect {
//            aspectBar.selectAspect(aspect, isSelected: true)
//        }
//        aspectBar.delegate = self
//        view.addSubview(aspectBar)
//
//        loadValuesAsync(forAsset: blurryAsset.urlAsset)
//
//        let tapGr = UITapGestureRecognizer(target: self, action: #selector(playerWasTouched))
//        playerView.addGestureRecognizer(tapGr)
//
//        logOUT()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        logIN()
//        super.viewWillAppear(animated)
//
//        addObserver(self, forKeyPath: KeyPath.duration, options: [.new, .initial], context: &aspectPlayerKVOContext)
//        addObserver(self, forKeyPath: KeyPath.rate, options: [.new, .initial], context: &aspectPlayerKVOContext)
//        addObserver(self, forKeyPath: KeyPath.status, options: [.new, .initial], context: &aspectPlayerKVOContext)
//
//        playerView.player = player
//        blurryPlayerView.player = player
//
//        updateLayout()
//        logOUT()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        removeObserver(self, forKeyPath: KeyPath.duration, context: &aspectPlayerKVOContext)
//        removeObserver(self, forKeyPath: KeyPath.rate, context: &aspectPlayerKVOContext)
//        removeObserver(self, forKeyPath: KeyPath.status, context: &aspectPlayerKVOContext)
//
//        player.pause()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateLayout()
//    }
//
//    private func playerFrame(for aspect: Aspect) -> CGRect {
//        let top: CGFloat = (parent as? NavigationController)?.navigationBarHeight ?? 0
//        let availableFrame = CGRect(x: 0,
//                                    y: top,
//                                    width: view.frame.size.width,
//                                    height: view.frame.size.height - aspectBarHeight - top).insetBy(dx: playerViewMargin, dy: playerViewMargin)
//        let playerSize = availableFrame.sizeThatFitsInside(withAspect: CGFloat(aspect.ratio))
//        return CGRect(center: availableFrame.frameCenter, size: playerSize)
//    }
//
//    func updateLayout() {
//        var playerFrame: CGRect!
//        playerFrame = self.playerFrame(for: currentAspect!)
//        blurryPlayerView.frame = playerFrame
//        blurryPlayerView.updateLayout()
//        playerView.frame = playerFrame
//        aspectBar.frame = CGRect(x: 0, y: view.frame.size.height - aspectBarHeight, width: view.frame.size.width, height: aspectBarHeight)
//    }
//
//    private func loadValuesAsync(forAsset asset: AVAsset) {
//        asset.loadValuesAsynchronously(forKeys: assetKeysRequiredToPlay) {
//            DispatchQueue.main.async { [weak self] in
//                guard let weakSelf = self else { return }
//                for key in weakSelf.assetKeysRequiredToPlay {
//                    var error: NSError?
//                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
//                        logError("Can't use this AVAsset because one of it's keys failed to load.")
//                        if let error = error {
//                            logError(error.localizedDescription)
//                        }
//                        // TODO: Handle error
//                        return
//                    }
//                }
//                if !asset.isPlayable || asset.hasProtectedContent {
//                    logError("Can't use this AVAsset because it isn't playable or has protected content")
//                    // TODO: Handle error
//                    return
//                }
//                weakSelf.playerItem = AVPlayerItem(asset: asset)
//            }
//        }
//    }
//
//    func playFromBeginning() {
//        // Go to beginning.
//        player.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler:
//            { [weak self] (isFinished: Bool) -> Void in
//                guard let weakSelf = self else { return }
//                // Start playing if user hasn't paused while seeking.
//                if !weakSelf.userPaused {
//                    weakSelf.player.play()
//                }
//        })
//    }
//
//    @objc func playerWasTouched() {
//        // Play/pause
//        userPaused = !userPaused
//        if userPaused {
//            player.pause()
//        } else {
//            player.play()
//        }
//    }
//}
//
//extension AspectViewController: AspectBarDelegate {
//
//    func aspectBar(_ bar: AspectBar, didChangeAspect newAspect: Aspect) {
//        currentAspect = newAspect
//        UIView.animate(withDuration: 0.4, delay: 0,
//                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
//                       options: [.curveEaseOut, .beginFromCurrentState],
//                       animations: {
//                        self.updateLayout()
//        }, completion: nil)
//    }
//}
//
//// MARK: - KVO Observation
//
//private var aspectPlayerKVOContext = 0
//
//private struct KeyPath {
//
//    static let duration = #keyPath(AspectViewController.player.currentItem.duration)
//    static let rate = #keyPath(AspectViewController.player.rate)
//    static let status = #keyPath(AspectViewController.player.currentItem.status)
//}
//
//extension AspectViewController {
//
//    // Update our UI when player or `player.currentItem` changes.
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        guard context == &aspectPlayerKVOContext else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        if keyPath == KeyPath.duration {
//            // Enable/disable controls when duration > 0.0
//            // Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when `player.currentItem` is nil.
//            let newDuration: CMTime
//            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
//                newDuration = newDurationAsValue.timeValue
//            } else {
//                newDuration = kCMTimeZero
//            }
//
//            let hasValidDuration = (newDuration.isNumeric && newDuration.value != 0)
//
//            // Start playing immediately if it has valid duration.
//            if hasValidDuration && !player.isPlaying {
//                player.play()
//            }
//
//        } else if keyPath == KeyPath.rate {
//            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
//            logDebug("rate: \(newRate)")
//
//            let isPlaying = (newRate == 1.0)
//
//            // Start playing immediately from beginning when playback reaches end.
//            if let currentItem = player.currentItem {
//                if !isPlaying && CMTimeCompare(player.currentTime(), currentItem.duration) == 0 {
//                    playFromBeginning()
//                }
//            }
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
//            if newStatus == .failed {
//                if let error = player.currentItem?.error {
//                    logError(error.localizedDescription)
//                }
//                // TODO: Handle/display error with message
//            }
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
//// MARK: - UI Constants
//
//private let playerViewMargin: CGFloat = 4
//
//extension AspectViewController {
//
//    var aspectBarHeight: CGFloat {
//        return 80
//    }
//}

