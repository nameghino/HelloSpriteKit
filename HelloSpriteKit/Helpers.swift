//
//  Helpers.swift
//  HelloSpriteKit
//
//  Created by Nicolas Ameghino on 6/16/14.
//  Copyright (c) 2014 Nicolas Ameghino. All rights reserved.
//

import UIKit
import SpriteKit

extension String {
    init(vector: CGVector) {
        String.init("dx: \(vector.dx) dy: \(vector.dy)")
    }
}

func myRand() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

func randBetween(low: CGFloat, and high: CGFloat) -> CGFloat {
    return (high - low) * myRand() + low
}
