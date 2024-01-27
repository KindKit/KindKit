//
//  KindKit
//

import KindNumeric

extension OrientedBox2 : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.shape.isZero && self.angle.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(
            shape: .zero,
            angle: .zero
        )
    }
    
}

extension OrientedBox2 : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(
            shape: .infinity,
            angle: .infinity
        )
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.shape.isFinite && self.angle.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.shape.isInfinite && self.angle.isInfinite
    }
    
}

extension OrientedBox2 : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(
            shape: .epsilon,
            angle: .epsilon
        )
    }
    
}

extension OrientedBox2 : MinTrait {
    
    public static var min: Self {
        return .init(
            shape: .min,
            angle: .zero
        )
    }
    
}

extension OrientedBox2 : ComponentMinTrait {
    
    @inlinable
    public func min(component other: Self) -> Self {
        return .init(
            shape: self.shape.min(component: other.shape),
            angle: self.angle.min(other.angle)
        )
    }
    
}

extension OrientedBox2 : MaxTrait {
    
    public static var max: Self {
        return .init(
            shape: .max,
            angle: .zero
        )
    }
    
}

extension OrientedBox2 : ComponentMaxTrait {
    
    @inlinable
    public func max(component other: Self) -> Self {
        return .init(
            shape: self.shape.max(component: other.shape),
            angle: self.angle.max(other.angle)
        )
    }
    
}

extension OrientedBox2 : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            shape: self.shape.negating(),
            angle: self.angle.negating()
        )
    }
    
}

extension OrientedBox2 : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            shape: self.shape.adding(on: other.shape),
            angle: self.angle.adding(on: other.angle)
        )
    }
    
}

extension OrientedBox2 : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            shape: self.shape.subtracting(this: other.shape),
            angle: self.angle.subtracting(this: other.angle)
        )
    }
    
}

extension OrientedBox2 : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            shape: self.shape.doubled(),
            angle: self.angle.doubled()
        )
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(
            shape: self.shape.multiplying(by: other.shape),
            angle: self.angle.multiplying(by: other.angle)
        )
    }
    
}

extension OrientedBox2 : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(
            shape: self.shape.halved(),
            angle: self.angle.halved()
        )
    }
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(
            shape: self.shape.dividing(this: other.shape),
            angle: self.angle.dividing(this: other.angle)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(
            shape: self.shape.remainder(dividingBy: other.shape),
            angle: self.angle.remainder(dividingBy: other.angle)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(
            shape: self.shape.truncatingRemainder(dividingBy: other.shape),
            angle: self.angle.truncatingRemainder(dividingBy: other.angle)
        )
    }
    
}

extension OrientedBox2 : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.shape.isLess(other.shape, tolerance: tolerance.shape)
            && self.angle.isLess(other.angle, tolerance: tolerance.angle)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.shape.isMore(other.shape, tolerance: tolerance.shape)
            && self.angle.isMore(other.angle, tolerance: tolerance.angle)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.shape.isLessOrEqual(other.shape, tolerance: tolerance.shape)
            && self.angle.isLessOrEqual(other.angle, tolerance: tolerance.angle)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.shape.isMoreOrEqual(other.shape, tolerance: tolerance.shape)
            && self.angle.isMoreOrEqual(other.angle, tolerance: tolerance.angle)
    }
    
}

extension OrientedBox2 : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.shape.isEqual(other.shape, tolerance: tolerance.shape)
            && self.angle.isEqual(other.angle, tolerance: tolerance.angle)
    }
    
}

extension OrientedBox2 : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.shape.isValid && self.angle.isValid
    }
    
    @inlinable
    public var validated: Self {
        return .init(
            shape: self.shape.validated,
            angle: self.angle.validated
        )
    }
    
}

extension OrientedBox2 : RoundTrait {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            shape: self.shape.rounded(rule),
            angle: self.angle
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            shape: self.shape.rounded(to: digits),
            angle: self.angle
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            shape: self.shape.truncated(to: digits),
            angle: self.angle
        )
    }
    
}

extension OrientedBox2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            shape: self.shape.lerp(to.shape, by: progress),
            angle: self.angle.lerp(to.angle, by: progress)
        )
    }
    
}
