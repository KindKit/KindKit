//
//  KindKitMath
//

import Foundation

public typealias CircleFloat = Circle< Float >
public typealias CircleDouble = Circle< Double >

public struct Circle< ValueType: IScalar & Hashable > : Hashable {
    
    public var origin: Point< ValueType >
    public var radius: ValueType
    
    @inlinable
    public init(
        origin: Point< ValueType >,
        radius: ValueType
    ) {
        self.origin = origin
        self.radius = radius
    }
    
    @inlinable
    public init(
        origin: Point< ValueType >,
        radius: Distance< ValueType >
    ) {
        self.origin = origin
        self.radius = radius.real
    }
    
}

public extension Circle {
    
    @inlinable
    func isContains(_ point: Point< ValueType >) -> Bool {
        let distance = self.origin.distance(point)
        return distance.real.abs <= self.radius
    }
    
    @inlinable
    func isIntersects(_ other: Self) -> Bool {
        return Intersection2.possibly(self, other)
    }
    
    @inlinable
    func intersection(_ other: Self) -> Intersection2< ValueType >.CircleToCircle {
        return Intersection2.find(self, other)
    }
    
}
