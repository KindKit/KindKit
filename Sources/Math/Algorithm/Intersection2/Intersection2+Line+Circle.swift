//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum LineToCircle : Equatable {
        case none
        case one(PointType)
        case two(PointType, PointType)
    }
    
}

public extension Intersection2 {
    
    static func possibly(_ line: LineType, _ circle: CircleType) -> Bool {
        let delta = circle.origin - line.origin
        let distance = Distance(squared: delta.dot(delta))
        return distance.real <= circle.radius
    }
    
    static func find(_ line: LineType, _ circle: CircleType) -> LineToCircle {
        let delta = circle.origin - line.origin
        let a1 = delta.dot(delta) - circle.radius * circle.radius
        let a2 = line.direction.dot(delta)
        let d = Distance(squared: a2 * a2 - a1)
        if d.squared > 0 {
            let dv = d.real
            let i1 = -a2 - dv
            let i2 = -a2 + dv
            return .two(
                line.origin + i1 * line.direction,
                line.origin + i2 * line.direction
            )
        } else if d.squared ~~ 0 {
            let i = -a2
            return .one(
                line.origin + i * line.direction
            )
        }
        return .none
    }
    
}