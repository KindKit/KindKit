//
//  KindKit
//

import KindNumeric

extension Anchor2 : MinTrait {
    
    public static var min: Self {
        return .init(both: .min)
    }
    
}

extension Anchor2 : ComponentMinTrait {
    
    @inlinable
    public func min(component other: Self) -> Self {
        return .init(
            x: self.x.min(other.x),
            y: self.y.min(other.y)
        )
    }
    
}

extension Anchor2 : MaxTrait {
    
    public static var max: Self {
        return .init(both: .max)
    }
    
}

extension Anchor2 : ComponentMaxTrait {
    
    @inlinable
    public func max(component other: Self) -> Self {
        return .init(
            x: self.x.max(other.x),
            y: self.y.max(other.y)
        )
    }
    
}

extension Anchor2 : EpsilonTrait {
    
    @inlinable
    public static var epsilon: Self {
        return .init(both: .epsilon)
    }
    
}

extension Anchor2 : NegativeTrait {
    
    @inlinable
    public func negating() -> Self {
        return .init(
            x: self.x.negating(),
            y: self.y.negating()
        )
    }
    
}

extension Anchor2 : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            x: self.x.adding(on: other.x),
            y: self.y.adding(on: other.y)
        )
    }
    
}

extension Anchor2 : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            x: self.x.subtracting(this: other.x),
            y: self.y.subtracting(this: other.y)
        )
    }
    
}

extension Anchor2 : MulTrait {
    
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

extension Anchor2 : DivTrait {
    
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

extension Anchor2 : InvertTrait {
    
    @inlinable
    public var invert: Self {
        return self.negating()
    }
    
}

extension Anchor2 : NormalizeTrait {
    
    public var canNormalize: Bool {
        return self.x.canNormalize || self.y.canNormalize
    }
    
    @inlinable
    public var normalized: Self {
        return .init(
            x: self.x.normalized,
            y: self.y.normalized
        )
    }
    
}

extension Anchor2 : NearCompareTrait {
    
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

extension Anchor2 : NearEqualTrait {
    
    @inlinable
    public func isEqual(_ other: Self, tolerance: Self) -> Bool {
        return self.x.isEqual(other.x, tolerance: tolerance.x)
            && self.y.isEqual(other.y, tolerance: tolerance.y)
    }
    
}

extension Anchor2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            x: self.x.lerp(to.x, by: progress),
            y: self.y.lerp(to.y, by: progress)
        )
    }
    
}
