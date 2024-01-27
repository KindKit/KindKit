//
//  KindKit
//

extension Percent : MinTrait {
    
    @inlinable
    public static var min: Self {
        return .init(value: .zero)
    }
    
}

extension Percent : MaxTrait {
    
    @inlinable
    public static var max: Self {
        return .init(value: .one)
    }
    
}

extension Percent : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(value: .epsilon)
    }
    
}

extension Percent : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(value: self.value.negating())
    }
    
}

extension Percent : AddTrait {
    
    @inlinable
    public func adding(on addend: Self) -> Self {
        return .init(value: self.value.adding(on: addend.value))
    }
    
}

extension Percent : SubTrait {
    
    @inlinable
    public func subtracting(this other: Percent) -> Percent {
        return .init(value: self.value.subtracting(this: other.value))
    }
    
}

extension Percent : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(value: self.value.doubled())
    }
    
    @inlinable
    public func multiplying(by other: Percent) -> Percent {
        return .init(value: self.value.multiplying(by: other.value))
    }
    
}

extension Percent : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(value: self.value.halved())
    }
    
    @inlinable
    public func dividing(this other: Percent) -> Percent {
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

extension Percent : NearCompareTrait {
    
    @inlinable
    public func isLessOrEqual(_ other: Percent, tolerance: Percent) -> Bool {
        return self.value.isLessOrEqual(other.value, tolerance: tolerance.value)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Percent, tolerance: Percent) -> Bool {
        return self.value.isMoreOrEqual(other.value, tolerance: tolerance.value)
    }
    
}

extension Percent : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.value.isEqual(other.value, tolerance: tolerance.value)
    }
    
}

extension Percent : InvertTrait {
    
    @inlinable
    public var invert: Self {
        return .max - self
    }
    
}

extension Percent : NormalizeTrait {
    
    @inlinable
    public var canNormalize: Bool {
        return self < .min || self > .max
    }
    
    @inlinable
    public var normalized: Self {
        return self.clamp(.min, .max)
    }
    
}

extension Percent : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Self) -> Self {
        return .init(value: self.value.lerp(to.value, by: progress))
    }
    
}
