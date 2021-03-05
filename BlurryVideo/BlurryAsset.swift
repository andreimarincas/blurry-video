//
//  BlurryAsset.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/22/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import UIKit
import AVFoundation

class BlurryAsset: NSObject {
    
    var urlAsset: AVURLAsset!
    
    // PHPhoto asset identifier
    var localIdentifier: String = ""
    
    // Aspect will be set async on init.
    dynamic var originalAspect: Aspect?
    
    dynamic var currentAspect: Aspect?
    
    // Creates a blurry asset with an URLAsset.
    // Use the public assetWithURLAsset(AVURLAsset) method to create blurry assets, it will return an existing one if already in blurring process.
    private init(urlAsset: AVURLAsset) {
        super.init()
        self.urlAsset = urlAsset
        setAspectRatioAsync()
    }
    
    // Creates an asset with an URLAsset.
    // If there already is a blurry asset with the given URLAsset which is blurring in progress, that one will be returned instead.
    class func assetWithURLAsset(urlAsset: AVURLAsset) -> BlurryAsset {
        if let asset = BlurryAssetManager.shared.assetWithURL(url: urlAsset.url) {
            return asset
        }
        return BlurryAsset(urlAsset: urlAsset)
    }
    
    private func setAspectRatioAsync() {
        let asset = self.urlAsset
        loadVideoTracksAsync(forAsset: asset!) { [weak self] (tracks: [AVAssetTrack], error: NSError?) in
            guard let weakSelf = self else { return }
            guard asset == weakSelf.urlAsset else { return }
            if let error = error {
                logError(error.localizedDescription)
                return
            }
            if let track = tracks.first {
                let size = track.naturalSize.applying(track.preferredTransform)
                let width = Int(fabs(size.width))
                let height = Int(fabs(size.height))
                // Reduce the fraction width/height to lowest terms.
                let d = gcd(width, height)
                weakSelf.originalAspect = Aspect(width: width / d, height: height / d)
            }
        }
    }
    
    private func loadVideoTracksAsync(forAsset urlAsset: AVURLAsset, completionHandler handler:@escaping (([AVAssetTrack], NSError?) -> Void)) {
        urlAsset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            DispatchQueue.main.async {
                var error: NSError?
                if urlAsset.statusOfValue(forKey: "tracks", error: &error) == .failed {
                    logError("Failed to load tracks for url asset.")
                    handler([], error)
                } else {
                    handler(urlAsset.tracks(withMediaType: AVMediaTypeVideo), nil)
                }
            }
        }
    }
}
