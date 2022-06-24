//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum BoxToBox : Equatable {
        case none
        case box(Box2< Value >)
    }
    
    @inlinable
    static func possibly(_ box1: Box2< Value >, _ box2: Box2< Value >) -> Bool {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        return u.x >= l.x && u.y >= l.y
    }
    
    @inlinable
    static func find(_ box1: Box2< Value >, _ box2: Box2< Value >) -> BoxToBox {
        let l = Swift.max(box1.lower, box2.lower)
        let u = Swift.min(box1.upper, box2.upper)
        let d = u - l
        if d.x >= 0, d.y >= 0 {
            return .box(Box2(lower: l, upper: u))
        }
        return .none
    }
    
}

public extension Box2 {
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Self? {
        switch Intersection2.find(self, other) {
        case .none: return nil
        case .box(let box): return box
        }
    }
    
}
