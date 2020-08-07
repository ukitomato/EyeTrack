//
//  Extentision.swift
//  
//
//  Created by Yuki Yamato on 2020/08/07.
//

import SceneKit

open extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
}

open func -(l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
}

open extension Collection where Element == CGFloat, Index == Int {
    var average: CGFloat? {
        guard !isEmpty else {
            return nil
        }
        let sum = reduce(CGFloat(0)) { first, second -> CGFloat in
            return first + second
        }

        return sum / CGFloat(count)
    }
}

open func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

open func /(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

open extension Collection where Element == CGPoint, Index == Int {
    var average: CGPoint? {
        guard !isEmpty else {
            return nil
        }

        let sum: CGPoint = reduce(CGPoint(x: 0, y: 0)) { first, second -> CGPoint in
            return first + second
        }

        return sum / CGFloat(count)
    }
}

