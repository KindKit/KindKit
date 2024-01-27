//
//  KindKit
//

import KindNumeric

public protocol DivDistanceTrait {
    
    func dividing(this other: Distance) -> Self
    
    func remainder(dividingBy other: Distance) -> Self
    
    func truncatingRemainder(dividingBy other: Distance) -> Self
    
}

public extension DivDistanceTrait {
    
    @inlinable
    static func / (lhs: Self, rhs: Distance) -> Self {
        return lhs.dividing(this: rhs)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Distance) {
        lhs = lhs.dividing(this: rhs)
    }
    
}

public extension DivDistanceTrait {
    
    @inlinable
    static func / (lhs: Self, rhs: SquaredDistance) -> Self {
        return lhs.dividing(this: rhs.distance)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: SquaredDistance) {
        lhs = lhs.dividing(this: rhs.distance)
    }
    
    @inlinable
    func dividing(this other: SquaredDistance) -> Self {
        return self.dividing(this: other.distance)
    }
    
    @inlinable
    func remainder(dividingBy other: SquaredDistance) -> Self {
        return self.remainder(dividingBy: other.distance)
    }
    
    @inlinable
    func truncatingRemainder(dividingBy other: SquaredDistance) -> Self {
        return self.remainder(dividingBy: other.distance)
    }
    
}
