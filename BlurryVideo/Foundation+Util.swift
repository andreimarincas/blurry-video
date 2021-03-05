//
//  Foundation+Util.swift
//  BlurryVideo
//
//  Created by Andrei Marincas on 1/15/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation

func  clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    var ret = value
    if ret < min {
        ret = min
    }
    if ret > max {
        ret = max
    }
    return ret
}

// Finds the greatest common divisor of two integers using Euclid's algorithm.
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = x
    var b = y
    while b != 0 {
        let t = b
        b = a % b
        a = t
    }
    return a
}
