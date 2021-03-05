//
//  VideoPlayerViewController.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

/*
 https://developer.apple.com/library/content/samplecode/AVFoundationSimplePlayer-iOS/Introduction/Intro.html
 https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/00_Introduction.html
 */

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    // Attempt load and test these asset keys before playing.
    let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    var playerView: PlayerView!
    var playerToolbar: VideoPlayerToolbar!
    
    let player = AVPlayer()
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            loadValuesAsync(forAsset: newAsset)
        }
    }
    
    var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    private var timeObserverToken: Any?
    
    let timescale: Int32 = 600
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, timescale)
            stopPlayingAndSeekSmoothlyToTime(newChaseTime: newTime)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var isFullscreen = false {
        didSet {
            if isFullscreen != oldValue {
                toggleFullscreen(on: isFullscreen, animated: true)
            }
        }
    }
    
    var isTracking = false
    var isSeekInProgress = false
    var chaseTime = kCMTimeZero
    var playerCurrentItemStatus: AVPlayerItemStatus = .unknown // player.currentItem.status
    var needsReplay = false
    
    var disableLayoutUpdates = false
    
    var transitionView: UIImageView? {
        didSet {
            guard transitionView != oldValue else { return }
            oldValue?.removeFromSuperview()
            if let transitionView = transitionView {
                transitionView.alpha = (playerItem != nil) ? 0 : 1
                view.addSubview(transitionView)
                updateLayout()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        playerView = PlayerView()
        playerView.backgroundColor = .clear
        playerView.playerLayer.backgroundColor = UIColor.clear.cgColor
        view.addSubview(playerView)
        
        playerToolbar = VideoPlayerToolbar()
        playerToolbar.playPauseButton.addTarget(self, action: #selector(playPauseButtonWasPressed(_:)), for: .touchUpInside)
        playerToolbar.timeSlider.addTarget(self, action: #selector(timeSliderDidChange(_:)), for: .valueChanged)
        playerToolbar.timeSlider.delegate = self
        playerToolbar.closeButton.addTarget(self, action: #selector(returnToPicker), for: .touchUpInside)
        view.addSubview(playerToolbar)
        
        let tapGr = UITapGestureRecognizer(target: self, action: #selector(playerWasTouched))
        playerView.addGestureRecognizer(tapGr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logIN()
        super.viewWillAppear(animated)
        
        addObserver(self, forKeyPath: KeyPath.duration, options: [.new, .initial], context: &videoPlayerKVOContext)
        addObserver(self, forKeyPath: KeyPath.rate, options: [.new, .initial], context: &videoPlayerKVOContext)
        addObserver(self, forKeyPath: KeyPath.status, options: [.new, .initial], context: &videoPlayerKVOContext)
        
        playerView.player = player
        
        let interval = CMTimeMake(1, timescale)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let weakSelf = self else { return }
            let timeElapsed = Float(CMTimeGetSeconds(time))
            if !weakSelf.isTracking && !weakSelf.isSeekInProgress {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: {
                    weakSelf.playerToolbar.timeSlider.setValue(timeElapsed, animated: true)
                }, completion: nil)
            }
            weakSelf.playerToolbar.elapsedTime = timeElapsed
        }
        
        updateLayout()
        
        AppDelegate.shared.mainViewController.viewControllerForStatusBarAppearance = self
        customNavigationController?.viewControllerForNavigationBarAppearance = self
        
        logOUT()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        logIN()
        super.viewDidDisappear(animated)
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        removeObserver(self, forKeyPath: KeyPath.duration, context: &videoPlayerKVOContext)
        removeObserver(self, forKeyPath: KeyPath.rate, context: &videoPlayerKVOContext)
        removeObserver(self, forKeyPath: KeyPath.status, context: &videoPlayerKVOContext)
        
        player.pause()
        
        logOUT()
    }
    
    private func loadValuesAsync(forAsset asset: AVAsset) {
        asset.loadValuesAsynchronously(forKeys: assetKeysRequiredToPlay) {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                guard asset == weakSelf.asset else { return }
                for key in weakSelf.assetKeysRequiredToPlay {
                    var error: NSError?
                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
                        logError("Can't use this AVAsset because one of it's keys failed to load.")
                        if let error = error {
                            logError(error.localizedDescription)
                        }
                        // TODO: Handle error
                        return
                    }
                }
                if !asset.isPlayable || asset.hasProtectedContent {
                    logError("Can't use this AVAsset because it isn't playable or has protected content")
                    // TODO: Handle error
                    return
                }
                weakSelf.playerItem = AVPlayerItem(asset: asset)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        guard !disableLayoutUpdates else { return }
        playerView.frame = view.bounds.insetBy(dx: -1, dy: -1) // Expand slightly to avoid blank margins.
        playerToolbar.frame = CGRect(x: 0,
                                     y: view.frame.size.height - playerToolbarHeight,
                                     width: view.frame.size.width,
                                     height: playerToolbarHeight)
        if let transitionView = transitionView {
            let image = transitionView.image!
            let aspect = image.size.width / image.size.height
            let fitSize = playerView.frame.sizeThatFitsInside(withAspect: aspect)
            let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
            transitionView.frame = CGRect(center: center, size: fitSize)
        }
    }
    
    func takePlayerSnapshot(at time: CMTime) -> UIImage? {
        guard let asset = playerItem?.asset else {
            return nil
        }
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        
        if let snapshot = try? imageGenerator.copyCGImage(at: time, actualTime: nil) {
            return UIImage(cgImage: snapshot)
        }
        return nil
    }
    
    func toggleFullscreen(on fullscreen: Bool, animated: Bool) {
        let toAlpha: CGFloat = fullscreen ? 0 : 1
        UIView.animate(withDuration: animated ? 0.3 : 0, delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseOut, .beginFromCurrentState],
                       animations: {
                        self.playerToolbar.alpha = toAlpha
                        self.playerView.backgroundColor = self.isFullscreen ? .black : .clear
                        self.setNeedsStatusBarAppearanceUpdate()
                        self.setNeedsNavigationBarAppearanceUpdate()
        }, completion: nil)
    }
    
    override var prefersNavigationBarHidden: Bool {
        return isFullscreen
    }
}

// MARK: - Actions
extension VideoPlayerViewController {
    
    @objc func playerWasTouched() {
        isFullscreen = !isFullscreen
    }
    
    @objc func playPauseButtonWasPressed(_ sender: UIButton) {
        if !player.isPlaying {
            if currentTime == duration {
                needsReplay = true
                currentTime = 0
            }
            player.play()
            isFullscreen = true
        } else {
            player.pause()
        }
    }
    
    @objc func timeSliderDidChange(_ sender: UISlider) {
        currentTime = Double(sender.value)
    }
    
    @objc func returnToPicker() {
        guard let pickerVC = parent as? VideoPickerViewController else { return }
        if let _ = playerItem {
            player.pause()
            let snapshot = takePlayerSnapshot(at: player.currentTime())
            pickerVC.transition(from: self, withTransitionImage: snapshot)
        } else {
            pickerVC.transition(from: self, withTransitionImage: transitionView?.image)
        }
    }
}

extension VideoPlayerViewController: TimeSliderDelegate {
    
    func slider(_ slider: TimeSlider, didChangeTracking isTracking: Bool) {
        self.isTracking = isTracking
    }
}

// MARK: - KVO Observation

private var videoPlayerKVOContext = 0

private struct KeyPath {
    
    static let duration = #keyPath(VideoPlayerViewController.player.currentItem.duration)
    static let rate = #keyPath(VideoPlayerViewController.player.rate)
    static let status = #keyPath(VideoPlayerViewController.player.currentItem.status)
}

extension VideoPlayerViewController {
    
    // Update our UI when player or `player.currentItem` changes.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &videoPlayerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == KeyPath.duration {
            // Update timeSlider and enable/disable controls when duration > 0.0
            // Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when `player.currentItem` is nil.
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            } else {
                newDuration = kCMTimeZero
            }
            
            let hasValidDuration = (newDuration.isNumeric && newDuration.value != 0)
            playerToolbar.playPauseButton.isEnabled = hasValidDuration
            playerToolbar.timeSlider.isEnabled = hasValidDuration
            
            let newDurationSeconds = hasValidDuration ? Float(CMTimeGetSeconds(newDuration)) : 0.0
            let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
            playerToolbar.timeSlider.maximumValue = newDurationSeconds
            playerToolbar.timeSlider.value = currentTime
            playerToolbar.elapsedTime = hasValidDuration ? currentTime : nil
            playerToolbar.duration = hasValidDuration ? newDurationSeconds : nil
            
        } else if keyPath == KeyPath.rate {
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            logDebug("rate: \(newRate)")
            
            let isPlaying = (newRate == 1.0)
            // Update `playPauseButton` image.
            let buttonImageName = isPlaying ? "pause-btn" : "play-btn"
            let buttonImage = UIImage(named: buttonImageName)
            playerToolbar.playPauseButton.setImage(buttonImage, for: .normal)
            
            // Exit fullscreen when reaches end.
            if let currentItem = player.currentItem {
                if !isPlaying && CMTimeCompare(player.currentTime(), currentItem.duration) == 0 {
                    isFullscreen = false
                }
            }
            
        } else if keyPath == KeyPath.status {
            // Display an error if status becomes `.Failed`.
            
            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                if let error = player.currentItem?.error {
                    logError(error.localizedDescription)
                }
                // TODO: Handle/display error with message
            }
            playerCurrentItemStatus = newStatus
        }
    }
    
    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration" : [KeyPath.duration],
            "rate" : [KeyPath.rate]
        ]
        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
    }
}

// MARK: - Smooth Video Scrubbing

/*
 Technical Q&A QA1820
 How do I achieve smooth video scrubbing with AVPlayer seekToTime:?
 
 Q:  My app allows the user to scrub video files using a slider control in combination with AVPlayer seekToTime: but there is a considerable lag in the display of the video frames. How can I achieve smoother scrubbing?
 
 A: Avoid making calls to AVPlayer seekToTime: in rapid succession. This will cancel the seeks in progress, resulting in a lot of seeking and not a lot of displaying of the target frames. Instead, use the completion handler variant of AVPlayer seekToTime:, and wait for a seek in progress to complete first before issuing another.
 
 https://developer.apple.com/library/content/qa/qa1820/_index.html
 */
extension VideoPlayerViewController {
    
    func stopPlayingAndSeekSmoothlyToTime(newChaseTime: CMTime) {
        player.pause()
        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    func trySeekToChaseTime() {
        if playerCurrentItemStatus == .unknown {
            // Wait until item becomes ready (KVO player.currentItem.status)
        } else if playerCurrentItemStatus == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        
        player.seek(to: seekTimeInProgress, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler:
            { [weak self] (isFinished: Bool) -> Void in
                guard let weakSelf = self else { return }
                
                if CMTimeCompare(seekTimeInProgress, weakSelf.chaseTime) == 0 {
                    weakSelf.isSeekInProgress = false
                    if CMTimeCompare(seekTimeInProgress, kCMTimeZero) == 0 && weakSelf.needsReplay {
                        weakSelf.needsReplay = false
                        weakSelf.player.play()
                    }
                } else {
                    weakSelf.trySeekToChaseTime()
                }
        })
    }
}

// MARK: - UI Constants

extension VideoPlayerViewController {
    
    var playerToolbarHeight: CGFloat {
        return 88
    }
}

// MARK: - Status Bar Appearance
extension VideoPlayerViewController {
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return isFullscreen || isLandscape
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
