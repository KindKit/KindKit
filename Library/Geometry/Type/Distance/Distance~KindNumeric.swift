//
//  KindKit
//

import KindNumeric

extension Distance : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.value.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(value: .zero)
    }
    
}

extension Distance : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(value: .epsilon)
    }
    
}

extension Distance : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(value: self.value.negating())
    }
    
}

extension Distance : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(value: self.value.adding(on: other.value))
    }
    
}

extension Distance : AddPercentTrait {
    
    public func adding(by other: Percent) -> Self {
        return .init(value: self.value.adding(by: other))
    }
    
}

extension Distance : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(value: self.value.subtracting(this: other.value))
    }
    
}

extension Distance : SubPercentTrait {
    
    public func subtracting(by other: Percent) -> Self {
        return .init(value: self.value.subtracting(by: other))
    }
    
}

extension Distance : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(value: self.value.doubled())
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(value: self.value.multiplying(by: other.value))
    }
    
}

extension Distance : MulPercentTrait {
    
    public func multiplying(by other: Percent) -> Self {
        return .init(value: self.value.multiplying(by: other))
    }
    
}

extension Distance : DivTrait {
    
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

extension Distance : FromNumberTrait {
    
    @inlinable
    public init< Input : BinaryInteger >(_ input: Input) {
        self.init(value: .init(input))
    }
    
    @inlinable
    public init< Input : BinaryFloatingPoint >(_ input: Input) {
        self.init(value: .init(input))
    }
    
}

extension Distance : NearCompareTrait {
    
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

extension Distance : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isEqual(other.value, tolerance: tolerance.value)
    }
    
}

extension Distance : RoundTrait {
    
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(value: self.value.rounded(rule))
    }
    
    public func rounded(to digits: UInt) -> Self {
        return .init(value: self.value.rounded(to: digits))
    }
    
    public func truncated(to digits: UInt) -> Self {
        return .init(value: self.value.truncated(to: digits))
    }
    
}

extension Distance : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(value: self.value.lerp(to.value, by: progress))
    }
    
}
