//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum BoxToBox : Equatable {
        case none
        case box(BoxType)
    }
    
    @inlinable
    static func possibly(_ box1: BoxType, _ box2: BoxType) -> Bool {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        return u.x >= l.x && u.y >= l.y
    }
    
    @inlinable
    static func find(_ box1: BoxType, _ box2: BoxType) -> BoxToBox {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        let d = u - l
        if d.x >= 0, d.y >= 0 {
            return .box(Box2(lower: l, upper: u))
        }
        return .none
    }
    
}
