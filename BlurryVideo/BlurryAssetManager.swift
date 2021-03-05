//
//  BlurryAssetManager.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/22/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation

class BlurryAssetManager: NSObject {
    
    static let shared = BlurryAssetManager()
    
    // Assets for which the blurring process is in progress.
    var blurringAssets: [BlurryAsset] = []
    
    // The current asset presented in Library, Aspect and Blurring view-controllers.
    // This is the asset the user selects first in Library and works with it to set its aspect and start blurring.
    dynamic var currentAsset: BlurryAsset?
    
    // Returns the asset with the given url if it is blurring in progress.
    func assetWithURL(url: URL) -> BlurryAsset? {
        return blurringAssets.first { $0.urlAsset.url == url }
    }
}
