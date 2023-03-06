//
//  KindKit
//

import Foundation

public struct Circle : Hashable {
    
    public var origin: Point
    public var radius: Double
    
    public init(
        origin: Point,
        radius: Double
    ) {
        self.origin = origin
        self.radius = radius
    }
    
    public init(
        origin: Point,
        radius: Distance
    ) {
        self.origin = origin
        self.radius = radius.real
    }
    
}

public extension Circle {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        let distance = self.origin.distance(point)
        return distance.real.abs <= self.radius
    }
    
}
