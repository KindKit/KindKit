//
//  KindKit
//

import KindNumeric

extension Rect : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.origin.isZero && self.size.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(
            origin: .zero,
            size: .zero
        )
    }
    
}

extension Rect : OneTrait {
    
    @inlinable
    public var isOne: Bool {
        return self.origin.isOne && self.size.isOne
    }
    
    @inlinable
    public static var one: Self {
        return .init(
            origin: .one,
            size: .one
        )
    }
    
}

extension Rect : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(
            origin: .infinity,
            size: .infinity
        )
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.origin.isFinite && self.size.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.origin.isInfinite && self.size.isInfinite
    }
    
}

extension Rect : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(
            origin: .epsilon,
            size: .epsilon
        )
    }
    
}

extension Rect : MinTrait {
    
    public static var min: Self {
        return .init(
            origin: .min,
            size: .min
        )
    }
    
}

extension Rect : ComponentMinTrait {
    
    @inlinable
    public func min(component other: Self) -> Self {
        return .init(
            origin: self.origin.min(component: other.origin),
            size: self.size.min(component: other.size)
        )
    }
    
}

extension Rect : MaxTrait {
    
    public static var max: Self {
        return .init(
            origin: .max,
            size: .max
        )
    }
    
}

extension Rect : ComponentMaxTrait {
    
    @inlinable
    public func max(component other: Self) -> Self {
        return .init(
            origin: self.origin.max(component: other.origin),
            size: self.size.max(component: other.size)
        )
    }
    
}

extension Rect : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            origin: self.origin.negating(),
            size: self.size.negating()
        )
    }
    
}

extension Rect : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            origin: self.origin.adding(on: other.origin),
            size: self.size.adding(on: other.size)
        )
    }
    
}

extension Rect : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            origin: self.origin.subtracting(this: other.origin),
            size: self.size.subtracting(this: other.size)
        )
    }
    
}

extension Rect : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            origin: self.origin.doubled(),
            size: self.size.doubled()
        )
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(
            origin: self.origin.multiplying(by: other.origin),
            size: self.size.multiplying(by: other.size)
        )
    }
    
}

extension Rect : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(
            origin: self.origin.halved(),
            size: self.size.halved()
        )
    }
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(
            origin: self.origin.dividing(this: other.origin),
            size: self.size.dividing(this: other.size)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(
            origin: self.origin.remainder(dividingBy: other.origin),
            size: self.size.remainder(dividingBy: other.size)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(
            origin: self.origin.truncatingRemainder(dividingBy: other.origin),
            size: self.size.truncatingRemainder(dividingBy: other.size)
        )
    }
    
}

extension Rect : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isLess(other.origin, tolerance: tolerance.origin)
            && self.size.isLess(other.size, tolerance: tolerance.size)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isMore(other.origin, tolerance: tolerance.origin)
            && self.size.isMore(other.size, tolerance: tolerance.size)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isLessOrEqual(other.origin, tolerance: tolerance.origin)
            && self.size.isLessOrEqual(other.size, tolerance: tolerance.size)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isMoreOrEqual(other.origin, tolerance: tolerance.origin)
            && self.size.isMoreOrEqual(other.size, tolerance: tolerance.size)
    }
    
}

extension Rect : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.origin.isEqual(other.origin, tolerance: tolerance.origin)
            && self.size.isEqual(other.size, tolerance: tolerance.size)
    }
    
}

extension Rect : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.origin.isValid && self.size.isValid
    }
    
    @inlinable
    public var validated: Self {
        return .init(
            origin: self.origin.validated,
            size: self.size.validated
        )
    }
    
}

extension Rect : RoundTrait {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            origin: self.origin.rounded(rule),
            size: self.size.rounded(rule)
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            origin: self.origin.rounded(to: digits),
            size: self.size.rounded(to: digits)
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            origin: self.origin.truncated(to: digits),
            size: self.size.truncated(to: digits)
        )
    }
    
}

extension Rect : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            origin: self.origin.lerp(to.origin, by: progress),
            size: self.size.lerp(to.size, by: progress)
        )
    }
    
}
