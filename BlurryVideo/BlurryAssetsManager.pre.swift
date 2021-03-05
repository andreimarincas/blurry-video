////
////  BlurryAssetsManager.swift
////  BlurryVideo
////
////  Created by Andrei Marincas on 1/24/18.
////  Copyright © 2018 Andrei Marincas. All rights reserved.
////
//
//import Foundation
//
//class BlurryAssetsManager: NSObject {
//    
//    static let shared = BlurryAssetsManager()
//    
//    var blurryAssets: [BlurryAsset] = []
//    
//    // This is the asset the user selects in Videos
//    dynamic var currentAsset: BlurryAsset?
//    
//    // Returns the asset with the given url if it is blurring in progress.
//    func assetWithURL(url: URL) -> BlurryAsset? {
//        return blurringAssets.first { $0.urlAsset.url == url }
//    }
//}
