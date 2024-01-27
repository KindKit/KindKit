//
//  KindKit
//

import KindNumeric

public typealias QuantityValueTrait = ZeroTrait & EpsilonTrait &
    MinTrait & MaxTrait &
    NegativeTrait &
    AddTrait & AddPercentTrait &
    SubTrait & SubPercentTrait &
    MulTrait & MulPercentTrait &
    DivTrait &
    NearCompareTrait & NearEqualTrait &
    RoundTrait

public protocol Quantity : Hashable, Equatable, Comparable, Sendable, QuantityValueTrait {
    
    associatedtype Unit : KindMeasure.Unit where Unit.Value : FromNumberTrait & QuantityValueTrait
    
    typealias Value = Unit.Value
    
    var value: Value { get }
    var unit: Unit { get }
    
    init(value: Value, unit: Unit)
    
}

public extension Quantity {
    
    @inlinable
    var raw: Value {
        return (self.value * self.unit.coefficient) + self.unit.constant
    }
    
    @inlinable
    var base: Self {
        return self.to(.base)
    }
    
}

public extension Quantity {
    
    @inlinable
    func value(to unit: Unit) -> Value {
        guard self.unit != unit else { return self.value }
        return (self.raw - unit.constant) / unit.coefficient
    }
    
    @inlinable
    func value< DerivedUnit : KindMeasure.DerivedUnit >(`as` unit: DerivedUnit) -> Value where Unit == DerivedUnit.SuperUnit {
        return (self.base.value - unit.constant) / unit.coefficient
    }
    
    @inlinable
    func to(_ unit: Unit) -> Self {
        return .init(value: self.value(to: unit), unit: unit)
    }
    
}

public extension Quantity where Unit : DerivedUnit {
    
    @inlinable
    func value< DerivedUnit : KindMeasure.DerivedUnit >(`as` unit: DerivedUnit) -> Value where Unit.SuperUnit == DerivedUnit.SuperUnit {
        return (self.base.value - unit.constant) / unit.coefficient
    }
    
}

// MARK: Equatable

extension Quantity {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value.isEqual(rhs.value(to: lhs.unit))
    }
    
}

// MARK: Comparable

extension Quantity {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value(to: lhs.unit)
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.value > rhs.value(to: lhs.unit)
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.value <= rhs.value(to: lhs.unit)
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.value >= rhs.value(to: lhs.unit)
    }
    
}

// MARK: EpsilonTrait

extension Quantity {
    
    @inlinable
    public static var epsilon: Self {
        return .init(value: .epsilon, unit: .base)
    }
    
}

// MARK: ZeroTrait

extension Quantity {
    
    @inlinable
    public static var zero: Self {
        return .init(value: .zero, unit: .base)
    }
    
}

// MARK: MinTrait

extension Quantity {
    
    @inlinable
    public static var min: Self {
        return .init(value: .min, unit: .base)
    }
    
}

// MARK: MaxTrait

extension Quantity {
    
    @inlinable
    public static var max: Self {
        return .init(value: .max, unit: .base)
    }
    
}

// MARK: NegativeTrait

extension Quantity {
    
    @inlinable
    public func negating() -> Self {
        return .init(value: -self.value, unit: self.unit)
    }
}

// MARK: AddTrait

extension Quantity {
    
    @inlinable
    public func adding(on addend: Self) -> Self {
        let value = self.value.adding(on: addend.value(to: self.unit))
        return .init(value: value, unit: self.unit)
    }
    
}

// MARK: SubTrait

extension Quantity {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        let value = self.value.subtracting(this: other.value(to: self.unit))
        return .init(value: value, unit: self.unit)
    }
    
}

// MARK: MulTrait

extension Quantity {
    
    @inlinable
    public func doubled() -> Self {
        return .init(value: self.value.doubled(), unit: self.unit)
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        let value = self.value.multiplying(by: other.value(to: self.unit))
        return .init(value: value, unit: self.unit)
    }
    
}

// MARK: MulPercentTrait

extension Quantity {
    
    @inlinable
    public func halved() -> Self {
        return .init(value: self.value.halved(), unit: self.unit)
    }
    
    @inlinable
    public func multiplying(by other: Percent) -> Self {
        let value = self.value.multiplying(by: other)
        return .init(value: value, unit: self.unit)
    }
    
}

// MARK: DivTrait

extension Quantity {
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        let value = self.value.dividing(this: other.value(to: self.unit))
        return .init(value: value, unit: self.unit)
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        let value = self.value.remainder(dividingBy: other.value(to: self.unit))
        return .init(value: value, unit: self.unit)
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        let value = self.value.truncatingRemainder(dividingBy: other.value(to: self.unit))
        return .init(value: value, unit: self.unit)
    }
    
}

// MARK: NearCompareTrait

extension Quantity {
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        let other = other.value(to: self.unit)
        let tolerance = tolerance.value(to: self.unit)
        return self.value.isLessOrEqual(other, tolerance: tolerance)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        let other = other.value(to: self.unit)
        let tolerance = tolerance.value(to: self.unit)
        return self.value.isMoreOrEqual(other, tolerance: tolerance)
    }
    
}

// MARK: NearEqualTrait

extension Quantity {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        let other = other.value(to: self.unit)
        let tolerance = tolerance.value(to: self.unit)
        return self.value.isEqual(other, tolerance: tolerance)
    }
    
}

// MARK: RoundTrait

extension Quantity {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            value: self.value.rounded(rule),
            unit: self.unit
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            value: self.value.rounded(to: digits),
            unit: self.unit
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            value: self.value.truncated(to: digits),
            unit: self.unit
        )
    }
    
}
