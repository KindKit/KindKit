//
//  KindKit
//

import Foundation
import KindCore

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
        let distance = self.origin.squaredLength(point)
        return distance.abs <= self.radius.squared
    }
    
}

public extension Circle {
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return .init(
            origin: lhs.origin * rhs,
            radius: lhs.radius * rhs
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs * rhs
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
