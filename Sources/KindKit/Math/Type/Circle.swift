//
//  KindKit
//

import Foundation

public struct Circle : Hashable {
    
    public var origin: Point
    public var radius: Distance
    
    public init(
        origin: Point,
        radius: Distance
    ) {
        self.origin = origin
        self.radius = radius
    }
    
}

public extension Circle {
    
    @inlinable
    func isContains(_ point: Point) -> Bool {
        let distance = self.origin.squaredDistance(point)
        return distance.abs <= self.radius.squared
    }
    
}
