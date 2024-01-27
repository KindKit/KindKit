//
//  KindKit
//

import KindNumeric

extension Radian : FromNumberTrait {
    
    @inlinable
    public init< Input : BinaryInteger >(_ input: Input) {
        self.init(value: .init(input))
    }
    
    @inlinable
    public init< Input : BinaryFloatingPoint >(_ input: Input) {
        self.init(value: .init(input))
    }
    
}

extension Radian : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.value.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(value: .zero)
    }
    
}

extension Radian : MinTrait {
    
    @inlinable
    public static var min: Self {
        return .init(value: -(2 * .pi))
    }
    
}

extension Radian : MaxTrait {
    
    @inlinable
    public static var max: Self {
        return .init(value: 2 * .pi)
    }
    
}

extension Radian : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(value: .infinity)
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.value.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.value.isInfinite
    }
    
}

extension Radian : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(value: .epsilon)
    }
    
}

extension Radian : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(value: self.value.negating())
    }
    
}

extension Radian : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(value: self.value.adding(on: other.value))
    }
    
}

extension Radian : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(value: self.value.subtracting(this: other.value))
    }
    
}

extension Radian : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(value: self.value.doubled())
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(value: self.value.multiplying(by: other.value))
    }
    
}

extension Radian : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(value: self.value.halved())
    }
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(value: self.value.dividing(this: other.value))
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(value: self.value.remainder(dividingBy: other.value))
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(value: self.value.truncatingRemainder(dividingBy: other.value))
    }
    
}

extension Radian : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.isWithin(.min, .max)
    }
    
    @inlinable
    public var validated: Self {
        var copy = self
        do {
            let limit = Self.min
            while copy <= limit {
                copy -= limit
            }
        }
        do {
            let limit = Self.max
            while copy >= limit {
                copy -= limit
            }
        }
        return copy
    }
    
}

extension Radian : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isEqual(other.value, tolerance: tolerance.value)
    }
    
}

extension Radian : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isLess(other.value, tolerance: tolerance.value)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isMore(other.value, tolerance: tolerance.value)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isLessOrEqual(other.value, tolerance: tolerance.value)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isMoreOrEqual(other.value, tolerance: tolerance.value)
    }
    
}

extension Radian : TrigonometricTrait {
    
    @inlinable
    public static var pi: Self {
        return .init(value: .pi)
    }
    
    @inlinable
    public var sin: Self {
        return .init(value: self.value.sin)
    }
    
    @inlinable
    public var asin: Self {
        return .init(value: self.value.asin)
    }
    
    @inlinable
    public var cos: Self {
        return .init(value: self.value.cos)
    }
    
    @inlinable
    public var acos: Self {
        return .init(value: self.value.acos)
    }
    
    @inlinable
    public var tan: Self {
        return .init(value: self.value.tan)
    }
    
    @inlinable
    public var atan: Self {
        return .init(value: self.value.atan)
    }
    
    @inlinable
    public func atan2(_ other: Self) -> Self {
        return .init(value: self.value.atan2(other.value))
    }
    
}

extension Radian : RoundTrait {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(value: self.value.rounded(rule))
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(value: self.value.rounded(to: digits))
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(value: self.value.truncated(to: digits))
    }
    
}

extension Radian : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(value: self.value.lerp(to.value, by: progress))
    }
    
}
