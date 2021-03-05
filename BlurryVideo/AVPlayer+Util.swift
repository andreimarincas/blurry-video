//
//  AVPlayer+Util.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/19/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        return rate == 1.0
    }
}
