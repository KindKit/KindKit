//
//  KindKit
//

import KindNumeric

extension Point : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.x.isZero && self.y.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(both: .zero)
    }
    
}

extension Point : OneTrait {
    
    @inlinable
    public var isOne: Bool {
        return self.x.isOne && self.y.isOne
    }
    
    @inlinable
    public static var one: Self {
        return .init(both: .one)
    }
    
}

extension Point : MinTrait {
    
    public static var min: Self {
        return .init(both: .min)
    }
    
}

extension Point : ComponentMinTrait {
    
    @inlinable
    public func min(component other: Self) -> Self {
        return .init(
            x: self.x.min(other.x),
            y: self.y.min(other.y)
        )
    }
    
}

extension Point : MaxTrait {
    
    public static var max: Self {
        return .init(both: .max)
    }
    
}

extension Point : ComponentMaxTrait {
    
    @inlinable
    public func max(component other: Self) -> Self {
        return .init(
            x: self.x.max(other.x),
            y: self.y.max(other.y)
        )
    }
    
}

extension Point : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(both: .infinity)
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.x.isFinite && self.y.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.x.isInfinite && self.y.isInfinite
    }
    
}

extension Point : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(both: .epsilon)
    }
    
}

extension Point : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            x: self.x.negating(),
            y: self.y.negating()
        )
    }
    
}

extension Point : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            x: self.x.adding(on: other.x),
            y: self.y.adding(on: other.y)
        )
    }
    
}

extension Point : AddNumberTrait {
    
    @inlinable
    public func adding< Added : BinaryInteger >(on number: Added) -> Self {
        return .init(
            x: self.x.adding(on: number),
            y: self.y.adding(on: number)
        )
    }
    
    @inlinable
    public func adding< Added : BinaryFloatingPoint >(on number: Added) -> Self {
        return .init(
            x: self.x.adding(on: number),
            y: self.y.adding(on: number)
        )
    }
    
}

extension Point : AddPercentTrait {
    
    @inlinable
    public func adding(by other: Percent) -> Self {
        return .init(
            x: self.x.adding(by: other),
            y: self.y.adding(by: other)
        )
    }
    
}

extension Point : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            x: self.x.subtracting(this: other.x),
            y: self.y.subtracting(this: other.y)
        )
    }
    
}

extension Point : SubNumberTrait {
    
    @inlinable
    public func subtracting< Added : BinaryInteger >(this number: Added) -> Self {
        return .init(
            x: self.x.subtracting(this: number),
            y: self.y.subtracting(this: number)
        )
    }
    
    @inlinable
    public func subtracting< Added : BinaryFloatingPoint >(this number: Added) -> Self {
        return .init(
            x: self.x.subtracting(this: number),
            y: self.y.subtracting(this: number)
        )
    }
    
}

extension Point : SubPercentTrait {
    
    @inlinable
    public func subtracting(by other: Percent) -> Self {
        return .init(
            x: self.x.subtracting(by: other),
            y: self.y.subtracting(by: other)
        )
    }
    
}

extension Point : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            x: self.x.doubled(),
            y: self.y.doubled()
        )
    }
    
    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(
            x: self.x.multiplying(by: other.x),
            y: self.y.multiplying(by: other.y)
        )
    }
    
}

extension Point : MulNumberTrait {
    
    @inlinable
    public func multiplying< Other : BinaryInteger >(by number: Other) -> Self {
        return .init(
            x: self.x.multiplying(by: number),
            y: self.y.multiplying(by: number)
        )
    }
    
    @inlinable
    public func multiplying< Other : BinaryFloatingPoint >(by number: Other) -> Self {
        return .init(
            x: self.x.multiplying(by: number),
            y: self.y.multiplying(by: number)
        )
    }
    
}

extension Point : MulPercentTrait {
    
    @inlinable
    public func multiplying(by other: Percent) -> Self {
        return .init(
            x: self.x.multiplying(by: other),
            y: self.y.multiplying(by: other)
        )
    }
    
}

extension Point : MulDistanceTrait {
    
    @inlinable
    public func multiplying(by other: Distance) -> Self {
        return .init(
            x: self.x.multiplying(by: other.value),
            y: self.y.multiplying(by: other.value)
        )
    }
    
}

extension Point : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(
            x: self.x.halved(),
            y: self.y.halved()
        )
    }
    
    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(
            x: self.x.dividing(this: other.x),
            y: self.y.dividing(this: other.y)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(
            x: self.x.remainder(dividingBy: other.x),
            y: self.y.remainder(dividingBy: other.y)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(
            x: self.x.truncatingRemainder(dividingBy: other.x),
            y: self.y.truncatingRemainder(dividingBy: other.y)
        )
    }
    
}

extension Point : DivNumberTrait {
    
    @inlinable
    public func dividing< Other : BinaryInteger >(this number: Other) -> Self {
        return .init(
            x: self.x.dividing(this: number),
            y: self.y.dividing(this: number)
        )
    }
    
    @inlinable
    public func dividing< Other : BinaryFloatingPoint >(this number: Other) -> Self {
        return .init(
            x: self.x.dividing(this: number),
            y: self.y.dividing(this: number)
        )
    }
    
    @inlinable
    public func remainder< Other : BinaryInteger >(dividingBy number: Other) -> Self {
        return .init(
            x: self.x.remainder(dividingBy: number),
            y: self.y.remainder(dividingBy: number)
        )
    }
    
    @inlinable
    public func remainder< Other : BinaryFloatingPoint >(dividingBy number: Other) -> Self {
        return .init(
            x: self.x.remainder(dividingBy: number),
            y: self.y.remainder(dividingBy: number)
        )
    }
    
    @inlinable
    public func truncatingRemainder< Other : BinaryInteger >(dividingBy number: Other) -> Self {
        return .init(
            x: self.x.truncatingRemainder(dividingBy: number),
            y: self.y.truncatingRemainder(dividingBy: number)
        )
    }
    
    @inlinable
    public func truncatingRemainder< Other : BinaryFloatingPoint >(dividingBy number: Other) -> Self {
        return .init(
            x: self.x.truncatingRemainder(dividingBy: number),
            y: self.y.truncatingRemainder(dividingBy: number)
        )
    }
    
}

extension Point : DivDistanceTrait {
        
    @inlinable
    public func dividing(this other: Distance) -> Self {
        return .init(
            x: self.x.dividing(this: other.value),
            y: self.y.dividing(this: other.value)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Distance) -> Self {
        return .init(
            x: self.x.remainder(dividingBy: other.value),
            y: self.y.remainder(dividingBy: other.value)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Distance) -> Self {
        return .init(
            x: self.x.truncatingRemainder(dividingBy: other.value),
            y: self.y.truncatingRemainder(dividingBy: other.value)
        )
    }
    
}

extension Point : InvertTrait {
    
    @inlinable
    public var invert: Self {
        return self.negating()
    }
    
}

extension Point : ValidationTrait {
    
    @inlinable
    public var isValid: Bool {
        return self.x.isValid && self.y.isValid
    }
    
    @inlinable
    public var validated: Self {
        return .init(
            x: self.x.validated,
            y: self.y.validated
        )
    }
    
}

extension Point : NormalizeTrait {
    
    public var canNormalize: Bool {
        return self.squaredLength.isMoreZero
    }
    
    @inlinable
    public var normalized: Normalized {
        let sl = self.squaredLength
        guard sl.isNotZero else {
            return .init(point: .zero, length: sl)
        }
        return .init(point: self / sl, length: sl)
    }
    
}

extension Point : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.x.isLess(other.x, tolerance: tolerance.x)
            && self.y.isLess(other.y, tolerance: tolerance.y)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.x.isMore(other.x, tolerance: tolerance.x)
            && self.y.isMore(other.y, tolerance: tolerance.y)
    }
    
    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.x.isLessOrEqual(other.x, tolerance: tolerance.x)
            && self.y.isLessOrEqual(other.y, tolerance: tolerance.y)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.x.isMoreOrEqual(other.x, tolerance: tolerance.x)
            && self.y.isMoreOrEqual(other.y, tolerance: tolerance.y)
    }
    
}

extension Point : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.x.isEqual(other.x, tolerance: tolerance.x)
            && self.y.isEqual(other.y, tolerance: tolerance.y)
    }
    
}

extension Point : RoundTrait {
    
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            x: self.x.rounded(rule),
            y: self.y.rounded(rule)
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            x: self.x.rounded(to: digits),
            y: self.y.rounded(to: digits)
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            x: self.x.truncated(to: digits),
            y: self.y.truncated(to: digits)
        )
    }
    
}

extension Point : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            x: self.x.lerp(to.x, by: progress),
            y: self.y.lerp(to.y, by: progress)
        )
    }
    
}
