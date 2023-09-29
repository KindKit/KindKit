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

extension Circle : IMapable {
}

extension Circle : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            origin: self.origin.lerp(to.origin, progress: progress),
            radius: self.radius.lerp(to.radius, progress: progress)
        )
    }
    
}
