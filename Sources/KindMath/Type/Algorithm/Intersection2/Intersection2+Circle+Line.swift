//
//  KindKit
//

import Foundation

extension Intersection2 {
    
    public typealias CircleToLine = LineToCircle
    
    @inlinable
    public static func possibly(_ circle: Circle, _ line: Line2) -> Bool {
        return Self.possibly(line, circle)
    }
    
    @inlinable
    public static func find(_ circle: Circle, _ line: Line2) -> CircleToLine? {
        return Self.find(line, circle)
    }
    
}

public extension Circle {
    
    @inlinable
    func isIntersects(_ other: Line2) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Line2) -> Intersection2.CircleToLine? {
        return Intersection2.find(self, other)
    }
    
}
