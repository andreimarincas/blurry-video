//
//  VideoPlayerToolbar.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class VideoPlayerToolbar: UIView {
    
    var timeSlider: TimeSlider!
    var startTimeLabel: UILabel! // elapsed time / remaining time
    var durationLabel: UILabel!
    var closeButton: UIButton!
    var playPauseButton: UIButton!
    
    // in seconds
    var elapsedTime: Float? {
        didSet {
            if elapsedTime != oldValue {
                if let elapsedTime = elapsedTime {
                    startTimeLabel.text = createTimeString(time: elapsedTime)
                    startTimeLabel.textColor = UIColor.black
                } else {
                    startTimeLabel.text = createTimeString(time: 0)
                    startTimeLabel.textColor = UIColor.lightGray
                }
                updateLayout()
            }
        }
    }
    
    // in seconds
    var duration: Float? {
        didSet {
            if duration != oldValue {
                if let duration = duration {
                    durationLabel.text = createTimeString(time: duration)
                    durationLabel.textColor = UIColor.black
                } else {
                    durationLabel.text = createTimeString(time: 0)
                    durationLabel.textColor = UIColor.lightGray
                }
                updateLayout()
            }
        }
    }
    
    let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackgroundBlur(style: .light, vibrancy: true)
        
        timeSlider = TimeSlider(frame: .zero)
        timeSlider.minimumTrackTintColor = .red
        timeSlider.maximumTrackTintColor = .lightGray
        timeSlider.setThumbImage(UIImage(named: "thumb")!, for: .normal)
        timeSlider.setThumbImage(UIImage(named: "thumb-disabled")!, for: .disabled)
        addSubview(timeSlider)
        
        startTimeLabel = UILabel()
        startTimeLabel.font = UIFont.applicationFont(ofSize: 10)
        startTimeLabel.textColor = UIColor.black
        startTimeLabel.textAlignment = .center
        startTimeLabel.text = createTimeString(time: 0)
        startTimeLabel.textColor = UIColor.lightGray
        addSubview(startTimeLabel)
        
        durationLabel = UILabel()
        durationLabel.font = UIFont.applicationFont(ofSize: 10)
        durationLabel.textColor = UIColor.black
        durationLabel.textAlignment = .center
        durationLabel.text = createTimeString(time: 0)
        durationLabel.textColor = UIColor.lightGray
        addSubview(durationLabel)
        
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "scale-down-btn")!, for: .normal)
        closeButton.setImage(UIImage(named: "scale-down-btn")!.withAlpha(0.3), for: .highlighted)
        addSubview(closeButton)
        
        playPauseButton = UIButton(type: .custom)
        playPauseButton.setImage(UIImage(named: "play-btn")!, for: .normal)
        playPauseButton.setImage(UIImage(named: "play-btn")!.withAlpha(0.3), for: .disabled)
        addSubview(playPauseButton)
        playPauseButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        backgroundBlurView!.frame = bounds.insetBy(top: topLineWidth, left: 0, bottom: 0, right: 0)
        closeButton.frame = CGRect(x: 0, y: frame.size.height - buttonSize.height, width: buttonSize.width, height: buttonSize.height)
        playPauseButton.frame = CGRect(center: CGPoint(x: frame.size.width / 2, y: frame.size.height - buttonSize.height / 2), size: buttonSize)
        let timeSliderCenter = CGPoint(x: frame.size.width / 2, y: (frame.size.height - buttonSize.height) / 2)
        timeSlider.frame = CGRect(center: timeSliderCenter, size: CGSize(width: frame.size.width - 2 * timeSliderMargin, height: timeSliderHeight))
        startTimeLabel.sizeToFit()
        startTimeLabel.frame = CGRect(origin: timeSlider.frame.bottomLeft.offsetBy(dx: 0, dy: timeLabelVerticalOffset), size: startTimeLabel.frame.size)
        durationLabel.sizeToFit()
        durationLabel.frame = CGRect(origin: timeSlider.frame.bottomRight.offsetBy(dx: -durationLabel.frame.size.width, dy: timeLabelVerticalOffset), size: durationLabel.frame.size)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTopLine(width: topLineWidth, color: .black)
    }
}

// MARK: - UI Constants

private let topLineWidth: CGFloat = 0.5

extension VideoPlayerToolbar {
    
    var buttonSize: CGSize {
        return CGSize(width: 50, height: 44)
    }
    
    var timeSliderMargin: CGFloat {
        return 22
    }
    
    var timeSliderHeight: CGFloat {
        return 31
    }
    
    var timeLabelVerticalOffset: CGFloat {
        return -8
    }
}
