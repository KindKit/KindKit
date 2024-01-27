//
//  KindKit
//

import KindNumeric

public struct Circle : Hashable, Equatable {
    
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
        let distance = self.origin.squaredLength(point)
        return distance.abs.isLessOrEqual(self.radius.squared)
    }
    
}
