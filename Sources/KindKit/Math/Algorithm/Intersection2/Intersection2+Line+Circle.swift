//
//  KindKit
//

import Foundation

public extension Intersection2 {
    
    enum LineToCircle : Equatable {
        
        case none
        case one(Point)
        case two(Point, Point)
        
    }
    
}

public extension Intersection2 {
    
    static func possibly(_ line: Line2, _ circle: Circle) -> Bool {
        let delta = circle.origin - line.origin
        let distance = Distance.Squared(delta.dot(delta))
        return distance <= circle.radius.squared
    }
    
    static func find(_ line: Line2, _ circle: Circle) -> LineToCircle {
        let delta = circle.origin - line.origin
        let a1 = delta.dot(delta) - (circle.radius * circle.radius).value
        let a2 = line.direction.dot(delta)
        let d = Distance.Squared(a2 * a2 - a1)
        if d.value > 0 {
            let dv = d.normal.value
            let i1 = -a2 - dv
            let i2 = -a2 + dv
            return .two(
                line.origin + i1 * line.direction,
                line.origin + i2 * line.direction
            )
        } else if d.value ~~ 0 {
            let i = -a2
            return .one(
                line.origin + i * line.direction
            )
        }
        return .none
    }
    
}

public extension Line2 {
    
    @inlinable
    func isIntersects(_ other: Circle) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Circle) -> Intersection2.LineToCircle {
        return Intersection2.find(self, other)
    }
    
}

public extension Circle {
    
    @inlinable
    func isIntersects(_ other: Line2) -> Bool {
        return Intersection2.possibly(other, self)
    }
    
    @inlinable
    func intersection(_ other: Line2) -> Intersection2.LineToCircle {
        return Intersection2.find(other, self)
    }
    
}
