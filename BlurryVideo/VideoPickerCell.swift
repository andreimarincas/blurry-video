//
//  VideoPickerCell.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/24/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit

class VideoPickerCell: UICollectionViewCell {
    
    var assetIdentifier: String?
    var thumbnailView: UIImageView!
    var durationLabel: UILabel!
    
    var thumbnailImage: UIImage? {
        didSet {
            thumbnailView.image = thumbnailImage
        }
    }
    
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }()
    
    // in seconds
    var duration: TimeInterval? {
        didSet {
            if let duration = self.duration {
                durationLabel.text = VideoPickerCell.durationFormatter.string(from: duration)
                durationLabel.isHidden = false
            } else {
                durationLabel.text = nil
                durationLabel.isHidden = true
            }
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        
        thumbnailView = UIImageView()
        thumbnailView.frame = contentView.bounds
        thumbnailView.contentMode = .scaleAspectFill
        contentView.addSubview(thumbnailView)
        
        durationLabel = UILabel()
        durationLabel.font = UIFont.semiboldApplicationFont(ofSize: 12)
        //        durationLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        durationLabel.textColor = UIColor.white
        durationLabel.textAlignment = .center
        //        durationLabel.layer.cornerRadius = 2
        //        durationLabel.layer.masksToBounds = true
        contentView.addSubview(durationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailView.frame = contentView.bounds
        durationLabel.sizeToFit()
        let durationLabelPadding: CGFloat = 4
        durationLabel.frame = durationLabel.frame.insetBy(dx: -durationLabelPadding, dy: 0)
        let durationLabelMarginRight: CGFloat = 5
        let durationLabelMarginBottom: CGFloat = 2
        durationLabel.frame = CGRect(x: contentView.frame.size.width - durationLabel.frame.size.width - durationLabelMarginRight,
                                     y: contentView.frame.size.height - durationLabel.frame.size.height - durationLabelMarginBottom,
                                     width: durationLabel.frame.size.width,
                                     height: durationLabel.frame.size.height).integral
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
        duration = nil
    }
}

class VideoPickerHeaderCell: UICollectionReusableView {
}

class VideoPickerFooterCell: UICollectionReusableView {
    
    var itemsCountLabel: UILabel!
    
    var itemsCount: Int = 0 {
        didSet {
            if itemsCount > 0 {
                if itemsCount == 1 {
                    itemsCountLabel.text = "1 video"
                } else {
                    itemsCountLabel.text = "\(itemsCount) videos"
                }
                itemsCountLabel.isHidden = false
            } else {
                itemsCountLabel.text = nil
                itemsCountLabel.isHidden = true
            }
            // TODO: Localize
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        itemsCountLabel = UILabel()
        itemsCountLabel.font = UIFont.applicationFont(ofSize: 14)
        itemsCountLabel.textAlignment = .center
        itemsCountLabel.textColor = UIColor.gray
        itemsCountLabel.isHidden = true
        addSubview(itemsCountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemsCountLabel.sizeToFit()
        itemsCountLabel.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }
}
