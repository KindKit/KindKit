//
//  KindKit
//

import KindNumeric

extension Size : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.width.isZero && self.height.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(both: .zero)
    }
    
}

extension Size : OneTrait {
    
    @inlinable
    public var isOne: Bool {
        return self.width.isOne && self.height.isOne
    }
    
    @inlinable
    public static var one: Self {
        return .init(both: .one)
    }
    
}

extension Size : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(both: .infinity)
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.width.isFinite && self.height.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.width.isInfinite && self.height.isInfinite
    }
    
}

extension Size : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(.epsilon)
    }
    
}

extension Size : MinTrait {
    
    public static var min: Self {
        return .init(both: .min)
    }
    
}

extension Size : ComponentMinTrait {
    
    @inlinable
    public func min(component other: Self) -> Self {
        return .init(
            width: self.width.min(other.width),
            height: self.height.min(other.height)
        )
    }
    
}

extension Size : MaxTrait {
    
    public static var max: Self {
        return .init(both: .max)
    }
    
}

extension Size : ComponentMaxTrait {
    
    @inlinable
    public func max(component other: Self) -> Self {
        return .init(
            width: self.width.max(other.width),
            height: self.height.max(other.height)
        )
    }
    
}

extension Size : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            width: self.width.negating(),
            height: self.height.negating()
        )
    }
    
}

extension Size : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            width: self.width + other.width,
            height: self.height + other.height
        )
    }
    
}

extension Size : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            width: self.width - other.width,
            height: self.height - other.height
        )
    }
    
}

extension Size : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            width: self.width.doubled(),
            height: self.height.doubled()
        )
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(
            width: self.width * other.width,
            height: self.height * other.height
        )
    }
    
}

extension Size : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(
            width: self.width.halved(),
            height: self.height.halved()
        )
    }
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(
            width: self.width / other.width,
            height: self.height / other.height
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(
            width: self.width.remainder(dividingBy: other.width),
            height: self.height.remainder(dividingBy: other.height)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(
            width: self.width.truncatingRemainder(dividingBy: other.width),
            height: self.height.truncatingRemainder(dividingBy: other.height)
        )
    }
    
}

extension Size : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.width.isLess(other.width, tolerance: tolerance.width)
            && self.height.isLess(other.height, tolerance: tolerance.height)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.width.isMore(other.width, tolerance: tolerance.width)
            && self.height.isMore(other.height, tolerance: tolerance.height)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.width.isLessOrEqual(other.width, tolerance: tolerance.width)
            && self.height.isLessOrEqual(other.height, tolerance: tolerance.height)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.width.isMoreOrEqual(other.width, tolerance: tolerance.width)
            && self.height.isMoreOrEqual(other.height, tolerance: tolerance.height)
    }
    
}

extension Size : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.width.isEqual(other.width, tolerance: tolerance.width)
            && self.height.isEqual(other.height, tolerance: tolerance.height)
    }
    
}

extension Size : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.width.isValid && self.height.isValid
    }
    
    @inlinable
    public var validated: Self {
        return .init(
            width: self.width.validated,
            height: self.height.validated
        )
    }
    
}

extension Size : NormalizeTrait {
    
    public var canNormalize: Bool {
        return self.width.canNormalize || self.height.canNormalize
    }
    
    @inlinable
    public var normalized: Size {
        return .init(
            width: self.width.normalized,
            height: self.height.normalized
        )
    }
    
}

extension Size : RoundTrait {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            width: self.width.rounded(rule),
            height: self.height.rounded(rule)
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            width: self.width.rounded(to: digits),
            height: self.height.rounded(to: digits)
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            width: self.width.truncated(to: digits),
            height: self.height.truncated(to: digits)
        )
    }
    
}

extension Size : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            width: self.width.lerp(to.width, by: progress),
            height: self.height.lerp(to.height, by: progress)
        )
    }
    
}
