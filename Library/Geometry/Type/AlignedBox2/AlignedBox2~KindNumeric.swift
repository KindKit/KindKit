//
//  KindKit
//

import KindNumeric

extension AlignedBox2 : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.lower.isZero && self.upper.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(
            lower: .zero,
            upper: .zero
        )
    }
    
}

extension AlignedBox2 : OneTrait {
    
    @inlinable
    public var isOne: Bool {
        return self.lower.isOne && self.upper.isOne
    }
    
    @inlinable
    public static var one: Self {
        return .init(
            lower: .one,
            upper: .one
        )
    }
    
}

extension AlignedBox2 : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(
            lower: .infinity,
            upper: .infinity
        )
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.lower.isFinite && self.upper.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.lower.isInfinite && self.upper.isInfinite
    }
    
}

extension AlignedBox2 : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(
            lower: .epsilon,
            upper: .epsilon
        )
    }
    
}

extension AlignedBox2 : MinTrait {
    
    public static var min: Self {
        return .init(
            lower: .min,
            upper: .min
        )
    }
    
}

extension AlignedBox2 : ComponentMinTrait {
    
    @inlinable
    public func min(component other: Self) -> Self {
        return .init(
            lower: self.lower.min(component: other.lower),
            upper: self.upper.min(component: other.upper)
        )
    }
    
}

extension AlignedBox2 : MaxTrait {
    
    public static var max: Self {
        return .init(
            lower: .max,
            upper: .max
        )
    }
    
}

extension AlignedBox2 : ComponentMaxTrait {
    
    @inlinable
    public func max(component other: Self) -> Self {
        return .init(
            lower: self.lower.max(component: other.lower),
            upper: self.upper.max(component: other.upper)
        )
    }
    
}

extension AlignedBox2 : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            lower: self.lower.negating(),
            upper: self.upper.negating()
        )
    }
    
}

extension AlignedBox2 : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            lower: self.lower.adding(on: other.lower),
            upper: self.upper.adding(on: other.upper)
        )
    }
    
}

extension AlignedBox2 : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            lower: self.lower.subtracting(this: other.lower),
            upper: self.upper.subtracting(this: other.upper)
        )
    }
    
}

extension AlignedBox2 : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            lower: self.lower.doubled(),
            upper: self.upper.doubled()
        )
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(
            lower: self.lower.multiplying(by: other.lower),
            upper: self.upper.multiplying(by: other.upper)
        )
    }
    
}

extension AlignedBox2 : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(
            lower: self.lower.halved(),
            upper: self.upper.halved()
        )
    }
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(
            lower: self.lower.dividing(this: other.lower),
            upper: self.upper.dividing(this: other.upper)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(
            lower: self.lower.remainder(dividingBy: other.lower),
            upper: self.upper.remainder(dividingBy: other.upper)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(
            lower: self.lower.truncatingRemainder(dividingBy: other.lower),
            upper: self.upper.truncatingRemainder(dividingBy: other.upper)
        )
    }
    
}

extension AlignedBox2 : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.lower.isLess(other.lower, tolerance: tolerance.lower)
            && self.upper.isLess(other.upper, tolerance: tolerance.upper)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.lower.isMore(other.lower, tolerance: tolerance.lower)
            && self.upper.isMore(other.upper, tolerance: tolerance.upper)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.lower.isLessOrEqual(other.lower, tolerance: tolerance.lower)
            && self.upper.isLessOrEqual(other.upper, tolerance: tolerance.upper)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.lower.isMoreOrEqual(other.lower, tolerance: tolerance.lower)
            && self.upper.isMoreOrEqual(other.upper, tolerance: tolerance.upper)
    }
    
}

extension AlignedBox2 : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.lower.isEqual(other.lower, tolerance: tolerance.lower)
            && self.upper.isEqual(other.upper, tolerance: tolerance.upper)
    }
    
}

extension AlignedBox2 : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.lower.isValid && self.upper.isValid
    }
    
    @inlinable
    public var validated: Self {
        return .init(
            lower: self.lower.validated,
            upper: self.upper.validated
        )
    }
    
}

extension AlignedBox2 : RoundTrait {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            lower: self.lower.rounded(rule),
            upper: self.upper.rounded(rule)
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            lower: self.lower.rounded(to: digits),
            upper: self.upper.rounded(to: digits)
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            lower: self.lower.truncated(to: digits),
            upper: self.upper.truncated(to: digits)
        )
    }
    
}

extension AlignedBox2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            lower: self.lower.lerp(to.lower, by: progress),
            upper: self.upper.lerp(to.upper, by: progress)
        )
    }
    
}
