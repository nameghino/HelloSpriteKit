// Playground - noun: a place where people can play
import Foundation
import UIKit

let point = CGPointMake(10, 10)
var r: CGPoint[] = []

for x in 0..2 {
    for y in 0..2 {
        let nx: CGFloat = point.x + 0.5 * (x % 2 == 0  ? -1 : 1)
        let ny: CGFloat = point.y + 0.5 * (y % 2 == 0  ? -1 : 1)
        r.append(CGPointMake(nx, ny))
    }
}

r
