//
//  AspectViewController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit
import AVFoundation

private var aspectViewControllerKVOContext = 0

class AspectViewController: UIViewController {
    
    // Attempt load and test these asset keys before playing.
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    var playerView: PlayerView!
//    var blurryPlayerView: BlurryPlayerView!
    var blurryPlayerView: PlayerView!
    var aspectBar: AspectBar!
    var currentAspect: Aspect?
    var effectView: UIVisualEffectView!
    
    let player = AVPlayer()
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    private var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    init(/*asset*/) {
        super.init(nibName: nil, bundle: nil)
        // TODO: Set current aspect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        logIN()
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
//        blurryPlayerView = BlurryPlayerView()
        blurryPlayerView = PlayerView()
        blurryPlayerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.addSubview(blurryPlayerView)
        
        let blur = UIBlurEffect(style: .light)
        effectView = UIVisualEffectView(effect: blur)
//        let vibrancy = UIVibrancyEffect(blurEffect: blur)
//        effectView.effect = vibrancy
        blurryPlayerView.addSubview(effectView)
        blurryPlayerView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        playerView = PlayerView()
        playerView.layer.borderWidth = 0.5
        playerView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(playerView)
        
        aspectBar = AspectBar()
        aspectBar.delegate = self
        view.addSubview(aspectBar)
        logOUT()
    }

    override func viewWillAppear(_ animated: Bool) {
        logIN()
        super.viewWillAppear(animated)
        
        addObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.duration), options: [.new, .initial], context: &aspectViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(AspectViewController.player.rate), options: [.new, .initial], context: &aspectViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.status), options: [.new, .initial], context: &aspectViewControllerKVOContext)
        
        blurryPlayerView.playerLayer.player = player
        playerView.playerLayer.player = player
        
        //        let movieURL = Bundle.main.url(forResource: "ElephantSeals", withExtension: "mov")!
//        let movieURL = Bundle.main.url(forResource: "IMG_0612", withExtension: "m4v")!
        let movieURL = Bundle.main.url(forResource: "IMG_1351", withExtension: "MOV")!
        //        let movieURL = Bundle.main.url(forResource: "ed28834f-68b6-462d-8d17-2ec169ae16f8", withExtension: "m4v")!
        
        asset = AVURLAsset(url: movieURL, options: nil)
        
        updateLayout()
        logOUT()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        logIN()
        super.viewDidDisappear(animated)
        
        removeObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.duration), context: &aspectViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(AspectViewController.player.rate), context: &aspectViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(AspectViewController.player.currentItem.status), context: &aspectViewControllerKVOContext)
        
        player.pause()
        
        logOUT()
    }
    
    private func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        logIN()
        newAsset.loadValuesAsynchronously(forKeys: AspectViewController.assetKeysRequiredToPlay) {
            DispatchQueue.main.async {
                guard newAsset == self.asset else { return }
                for key in AspectViewController.assetKeysRequiredToPlay {
                    var error: NSError?
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        logError("Can't use this AVAsset because one of it's keys failed to load.")
                        if let error = error {
                            logError(error.localizedDescription)
                        }
                        return
                    }
                }
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    logError("Can't use this AVAsset because it isn't playable or has protected content.")
                    return
                }
                self.playerItem = AVPlayerItem(asset: newAsset)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    private func playerFrame(for aspect: Aspect) -> CGRect {
        //let top: CGFloat = (parent as? NavigationController)?.navigationBarHeight ?? 0
        let top: CGFloat = 20
        let availableFrame = CGRect(x: 0,
                                    y: top,
                                    width: view.frame.size.width,
                                    height: view.frame.size.height - aspectBarHeight - top).insetBy(dx: playerViewMargin, dy: playerViewMargin)
        let playerSize = availableFrame.sizeThatFitsInside(withAspect: CGFloat(aspect.ratio))
        return CGRect(center: availableFrame.frameCenter, size: playerSize)
    }
    
    func updateLayout() {
        var playerFrame: CGRect!
        if let aspect = currentAspect {
            playerFrame = self.playerFrame(for: aspect)
        } else {
            playerFrame = view.bounds
        }
        blurryPlayerView.frame = playerFrame
//        blurryPlayerView.updateLayout()
        effectView.frame = blurryPlayerView.bounds
        playerView.frame = playerFrame
        aspectBar.frame = CGRect(x: 0, y: view.frame.size.height - aspectBarHeight, width: view.frame.size.width, height: aspectBarHeight)
    }
}

extension AspectViewController: AspectBarDelegate {
    
    func aspectBar(_ bar: AspectBar, didChangeAspect newAspect: Aspect) {
        currentAspect = newAspect
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                       options: [.curveEaseOut, .beginFromCurrentState],
                       animations: {
                        self.updateLayout()
        }, completion: nil)
    }
}

// MARK: - KVO Observation
extension AspectViewController {
    
    // Update our UI when player or `player.currentItem` changes.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &aspectViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == #keyPath(AspectViewController.player.rate) {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            logDebug("rate: \(newRate)")
            if newRate != 1.0 {
                // Not playing forward, so play.
                if currentTime == duration {
                    // At end, so got back to begining.
                    currentTime = 0.0
                }
                player.play()
            }
        }
        
        /*if keyPath == #keyPath(AspectViewController.player.currentItem.duration) {
         // Update timeSlider and enable/disable controls when duration > 0.0
         // Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when `player.currentItem` is nil.
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
         
         } else if keyPath == #keyPath(AspectViewController.player.rate) {
         let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
         logDebug("rate: \(newRate)")
         
         if newRate != 1.0 {
         // Not playing forward, so play.
         if currentTime == duration {
         // At end, so got back to begining.
         currentTime = 0.0
         }
         player.play()
         
         } else if keyPath == #keyPath(AspectViewController.player.currentItem.status) {
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
         }*/
    }
}

private let playerViewMargin: CGFloat = 4

// MARK: - UI Constants
extension AspectViewController {
    
    var aspectBarHeight: CGFloat {
        return 80
    }
}

