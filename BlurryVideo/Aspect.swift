//
//  Aspect.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/20/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation

typealias Aspect = AspectRatio

final class AspectRatio: NSObject {
    
    static let fullscreen = AspectRatio(width: 4, height: 3)!
    static let fullscreenPortrait = AspectRatio.fullscreen.reverse()!
    
    static let widescreen = AspectRatio(width: 16, height: 9)!
    static let widescreenPortrait = AspectRatio.widescreen.reverse()!
    
    let width: Int
    let height: Int
    
    init?(width: Int, height: Int) {
        guard width > 0 && height > 0 else {
            return nil
        }
        self.width = width
        self.height = height
    }
    
    func reverse() -> AspectRatio? {
        return AspectRatio(width: height, height: width)
    }
    
    var ratio: Float {
        return Float(width) / Float(height)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let aspect = object as? AspectRatio else { return false }
        return (width == aspect.width && height == aspect.height)
    }
}

