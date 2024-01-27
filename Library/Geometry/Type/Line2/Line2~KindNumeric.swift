//
//  KindKit
//

import KindNumeric

extension Line2 : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.origin.isZero && self.direction.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(
            origin: .zero,
            direction: .zero
        )
    }
    
}

extension Line2 : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(
            origin: .infinity,
            direction: .infinity
        )
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.origin.isFinite && self.direction.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.origin.isInfinite && self.direction.isInfinite
    }
    
}

extension Line2 : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(
            origin: .epsilon,
            direction: .epsilon
        )
    }
    
}

extension Line2 : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            origin: self.origin.negating(),
            direction: self.direction.negating()
        )
    }
    
}

extension Line2 : InvertTrait {
    
    @inlinable
    public var invert: Self {
        return .init(
            origin: self.origin,
            direction: self.direction.invert
        )
    }
    
}

extension Line2 : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isLess(other.origin, tolerance: tolerance.origin)
            && self.direction.isLess(other.direction, tolerance: tolerance.direction)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isMore(other.origin, tolerance: tolerance.origin)
            && self.direction.isMore(other.direction, tolerance: tolerance.direction)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isLessOrEqual(other.origin, tolerance: tolerance.origin)
            && self.direction.isLessOrEqual(other.direction, tolerance: tolerance.direction)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isMoreOrEqual(other.origin, tolerance: tolerance.origin)
            && self.direction.isMoreOrEqual(other.direction, tolerance: tolerance.direction)
    }
    
}

extension Line2 : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isEqual(other.origin, tolerance: tolerance.origin)
            && self.direction.isEqual(other.direction, tolerance: tolerance.direction)
    }
    
}

extension Line2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            origin: self.origin.lerp(to.origin, by: progress),
            direction: self.direction.lerp(to.direction, by: progress)
        )
    }
    
}
