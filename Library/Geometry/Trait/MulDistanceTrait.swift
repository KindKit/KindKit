//
//  KindKit
//

import KindNumeric

public protocol MulDistanceTrait {
    
    func multiplying(by other: Distance) -> Self
    
}

public extension MulDistanceTrait {
    
    @inlinable
    static func * (lhs: Self, rhs: Distance) -> Self {
        return lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func * (lhs: Distance, rhs: Self) -> Self {
        return rhs.multiplying(by: lhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Distance) {
        lhs = lhs.multiplying(by: rhs)
    }
    
}

public extension MulDistanceTrait {
    
    @inlinable
    func multiplying(by other: SquaredDistance) -> Self {
        return self.multiplying(by: other.distance)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: SquaredDistance) -> Self {
        return lhs.multiplying(by: rhs.distance)
    }
    
    @inlinable
    static func * (lhs: SquaredDistance, rhs: Self) -> Self {
        return rhs.multiplying(by: lhs.distance)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: SquaredDistance) {
        lhs = lhs.multiplying(by: rhs.distance)
    }
    
}
