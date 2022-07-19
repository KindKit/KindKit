//
//  KindKitMath
//

import Foundation

public typealias CircleFloat = Circle< Float >
public typealias CircleDouble = Circle< Double >

public struct Circle< Value : IScalar & Hashable > : Hashable {
    
    public var origin: Point< Value >
    public var radius: Value
    
    @inlinable
    public init(
        origin: Point< Value >,
        radius: Value
    ) {
        self.origin = origin
        self.radius = radius
    }
    
    @inlinable
    public init(
        origin: Point< Value >,
        radius: Distance< Value >
    ) {
        self.origin = origin
        self.radius = radius.real
    }
    
}

public extension Circle {
    
    @inlinable
    func isContains(_ point: Point< Value >) -> Bool {
        let distance = self.origin.distance(point)
        return distance.real.abs <= self.radius
    }
    
}
