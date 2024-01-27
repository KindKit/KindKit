//
//  KindKit
//

import KindNumeric

extension Inset : ZeroTrait {
    
    @inlinable
    public var isZero: Bool {
        return self.top.isZero && self.left.isZero && self.right.isZero && self.bottom.isZero
    }
    
    @inlinable
    public static var zero: Self {
        return .init(all: .zero)
    }
    
}

extension Inset : OneTrait {
    
    @inlinable
    public var isOne: Bool {
        return self.top.isOne && self.left.isOne && self.right.isOne && self.bottom.isOne
    }
    
    @inlinable
    public static var one: Self {
        return .init(all: .one)
    }
    
}

extension Inset : InfinityTrait {
    
    @inlinable
    public static var infinity: Self {
        return .init(all: .infinity)
    }
    
    @inlinable
    public var isFinite: Bool {
        return self.top.isFinite && self.left.isFinite && self.right.isFinite && self.bottom.isFinite
    }
    
    @inlinable
    public var isInfinite: Bool {
        return self.top.isInfinite && self.left.isInfinite && self.right.isInfinite && self.bottom.isInfinite
    }
    
}

extension Inset : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(all: .epsilon)
    }
    
}

extension Inset : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            top: self.top.negating(),
            left: self.left.negating(),
            right: self.right.negating(),
            bottom: self.bottom.negating()
        )
    }
    
}

extension Inset : AddTrait {

    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            top: self.top.adding(on: other.top),
            left: self.left.adding(on: other.left),
            right: self.right.adding(on: other.right),
            bottom: self.bottom.adding(on: other.bottom)
        )
    }
    
}

extension Inset : AddPercentTrait {

    @inlinable
    public func adding(by other: Percent) -> Self {
        return .init(
            top: self.top.adding(by: other),
            left: self.left.adding(by: other),
            right: self.right.adding(by: other),
            bottom: self.bottom.adding(by: other)
        )
    }
    
}

extension Inset : SubTrait {

    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            top: self.top.subtracting(this: other.top),
            left: self.left.subtracting(this: other.left),
            right: self.right.subtracting(this: other.right),
            bottom: self.bottom.subtracting(this: other.bottom)
        )
    }
    
}

extension Inset : SubPercentTrait {

    @inlinable
    public func subtracting(by other: Percent) -> Self {
        return .init(
            top: self.top.subtracting(by: other),
            left: self.left.subtracting(by: other),
            right: self.right.subtracting(by: other),
            bottom: self.bottom.subtracting(by: other)
        )
    }
    
}

extension Inset : MulTrait {
    
    @inlinable
    public func doubled() -> Self {
        return .init(
            top: self.top.doubled(),
            left: self.left.doubled(),
            right: self.right.doubled(),
            bottom: self.bottom.doubled()
        )
    }

    @inlinable
    public func multiplying(by other: Self) -> Self {
        return .init(
            top: self.top.multiplying(by: other.top),
            left: self.left.multiplying(by: other.left),
            right: self.right.multiplying(by: other.right),
            bottom: self.bottom.multiplying(by: other.bottom)
        )
    }
    
}

extension Inset : MulPercentTrait {

    @inlinable
    public func multiplying(by other: Percent) -> Self {
        return .init(
            top: self.top.multiplying(by: other),
            left: self.left.multiplying(by: other),
            right: self.right.multiplying(by: other),
            bottom: self.bottom.multiplying(by: other)
        )
    }
    
}

extension Inset : MulDistanceTrait {
    
    @inlinable
    public func multiplying(by other: Distance) -> Self {
        return .init(
            top: self.top.multiplying(by: other.value),
            left: self.left.multiplying(by: other.value),
            right: self.right.multiplying(by: other.value),
            bottom: self.bottom.multiplying(by: other.value)
        )
    }
    
}

extension Inset : DivTrait {
    
    @inlinable
    public func halved() -> Self {
        return .init(
            top: self.top.halved(),
            left: self.left.halved(),
            right: self.right.halved(),
            bottom: self.bottom.halved()
        )
    }

    @inlinable
    public func dividing(this other: Self) -> Self {
        return .init(
            top: self.top.dividing(this: other.top),
            left: self.left.dividing(this: other.left),
            right: self.right.dividing(this: other.right),
            bottom: self.bottom.dividing(this: other.bottom)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Self) -> Self {
        return .init(
            top: self.top.remainder(dividingBy: other.top),
            left: self.left.remainder(dividingBy: other.left),
            right: self.right.remainder(dividingBy: other.right),
            bottom: self.bottom.remainder(dividingBy: other.bottom)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Self) -> Self {
        return .init(
            top: self.top.truncatingRemainder(dividingBy: other.top),
            left: self.left.truncatingRemainder(dividingBy: other.left),
            right: self.right.truncatingRemainder(dividingBy: other.right),
            bottom: self.bottom.truncatingRemainder(dividingBy: other.bottom)
        )
    }
    
}

extension Inset : DivDistanceTrait {
    
    @inlinable
    public func dividing(this other: Distance) -> Self {
        return .init(
            top: self.top.dividing(this: other.value),
            left: self.left.dividing(this: other.value),
            right: self.right.dividing(this: other.value),
            bottom: self.bottom.dividing(this: other.value)
        )
    }
    
    @inlinable
    public func remainder(dividingBy other: Distance) -> Self {
        return .init(
            top: self.top.remainder(dividingBy: other.value),
            left: self.left.remainder(dividingBy: other.value),
            right: self.right.remainder(dividingBy: other.value),
            bottom: self.bottom.remainder(dividingBy: other.value)
        )
    }
    
    @inlinable
    public func truncatingRemainder(dividingBy other: Distance) -> Self {
        return .init(
            top: self.top.truncatingRemainder(dividingBy: other.value),
            left: self.left.truncatingRemainder(dividingBy: other.value),
            right: self.right.truncatingRemainder(dividingBy: other.value),
            bottom: self.bottom.truncatingRemainder(dividingBy: other.value)
        )
    }
    
}

extension Inset : NearCompareTrait {
    
    @inlinable
    public func isLess(_ other: Self, tolerance: Self) -> Bool {
        return self.top.isLess(other.top, tolerance: tolerance.top)
            && self.left.isLess(other.left, tolerance: tolerance.left)
            && self.right.isLess(other.right, tolerance: tolerance.right)
            && self.bottom.isLess(other.bottom, tolerance: tolerance.bottom)
    }
    
    @inlinable
    public func isMore(_ other: Self, tolerance: Self) -> Bool {
        return self.top.isMore(other.top, tolerance: tolerance.top)
            && self.left.isMore(other.left, tolerance: tolerance.left)
            && self.right.isMore(other.right, tolerance: tolerance.right)
            && self.bottom.isLessOrEqual(other.bottom, tolerance: tolerance.bottom)
    }

    @inlinable
    public func isLessOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.top.isLessOrEqual(other.top, tolerance: tolerance.top)
            && self.left.isLessOrEqual(other.left, tolerance: tolerance.left)
            && self.right.isLessOrEqual(other.right, tolerance: tolerance.right)
            && self.bottom.isLessOrEqual(other.bottom, tolerance: tolerance.bottom)
    }
    
    @inlinable
    public func isMoreOrEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.top.isMoreOrEqual(other.top, tolerance: tolerance.top)
            && self.left.isMoreOrEqual(other.left, tolerance: tolerance.left)
            && self.right.isMoreOrEqual(other.right, tolerance: tolerance.right)
            && self.bottom.isMoreOrEqual(other.bottom, tolerance: tolerance.bottom)
    }
    
}

extension Inset : NearEqualTrait {

    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.top.isEqual(other.top, tolerance: tolerance.top)
            && self.left.isEqual(other.left, tolerance: tolerance.left)
            && self.right.isEqual(other.right, tolerance: tolerance.right)
            && self.bottom.isEqual(other.bottom, tolerance: tolerance.bottom)
    }
    
}

extension Inset : RoundTrait {

    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return .init(
            top: self.top.rounded(rule),
            left: self.left.rounded(rule),
            right: self.right.rounded(rule),
            bottom: self.bottom.rounded(rule)
        )
    }
    
    @inlinable
    public func rounded(to digits: UInt) -> Self {
        return .init(
            top: self.top.rounded(to: digits),
            left: self.left.rounded(to: digits),
            right: self.right.rounded(to: digits),
            bottom: self.bottom.rounded(to: digits)
        )
    }
    
    @inlinable
    public func truncated(to digits: UInt) -> Self {
        return .init(
            top: self.top.truncated(to: digits),
            left: self.left.truncated(to: digits),
            right: self.right.truncated(to: digits),
            bottom: self.bottom.truncated(to: digits)
        )
    }
    
}

extension Inset : LerpTrait {

    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            top: self.top.lerp(to.top, by: progress),
            left: self.left.lerp(to.left, by: progress),
            right: self.right.lerp(to.right, by: progress),
            bottom: self.bottom.lerp(to.bottom, by: progress)
        )
    }
    
}
