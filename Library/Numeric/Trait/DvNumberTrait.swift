//
//  KindKit
//

import KindCore

public protocol DivNumberTrait {
	
    func dividing< Other : BinaryInteger >(this other: Other) -> Self
    
    func dividing< Other : BinaryFloatingPoint >(this other: Other) -> Self
    
    func remainder< Other : BinaryInteger >(dividingBy other: Other) -> Self
    
    func remainder< Other : BinaryFloatingPoint >(dividingBy other: Other) -> Self
    
    func truncatingRemainder< Other : BinaryInteger >(dividingBy other: Other) -> Self
    
    func truncatingRemainder< Other : BinaryFloatingPoint >(dividingBy other: Other) -> Self
    
}

public extension DivNumberTrait {
    
    @inlinable
    static func / < Right : BinaryInteger >(lhs: Self, rhs: Right) -> Self {
        return lhs.dividing(this: rhs)
    }
    
    @inlinable
    static func / < Right : BinaryFloatingPoint >(lhs: Self, rhs: Right) -> Self {
        return lhs.dividing(this: rhs)
    }
    
    @inlinable
    static func /= < Right : BinaryInteger >(lhs: inout Self, rhs: Right) {
        lhs = lhs.dividing(this: rhs)
    }
    
    @inlinable
    static func /= < Right : BinaryFloatingPoint >(lhs: inout Self, rhs: Right) {
        lhs = lhs.dividing(this: rhs)
    }
    
}

public extension DivNumberTrait where Self : FromNumberTrait & DivTrait {
    
    @inlinable
    func dividing< Other : BinaryInteger >(this other: Other) -> Self {
        return self.dividing(this: Self.init(other))
    }
    
    @inlinable
    func dividing< Other : BinaryFloatingPoint >(this other: Other) -> Self {
        return self.dividing(this: Self.init(other))
    }
    
    @inlinable
    func remainder< Other : BinaryInteger >(dividingBy other: Other) -> Self {
        return self.remainder(dividingBy: Self.init(other))
    }
    
    @inlinable
    func remainder< Other : BinaryFloatingPoint >(dividingBy other: Other) -> Self {
        return self.remainder(dividingBy: Self.init(other))
    }
    
    @inlinable
    func truncatingRemainder< Other : BinaryInteger >(dividingBy other: Other) -> Self {
        return self.truncatingRemainder(dividingBy: Self.init(other))
    }
    
    @inlinable
    func truncatingRemainder< Other : BinaryFloatingPoint >(dividingBy other: Other) -> Self {
        return self.truncatingRemainder(dividingBy: Self.init(other))
    }
    
}

public extension DivNumberTrait where Self : ZeroTrait {
    
    @inlinable
    var isInvertible: Bool {
        return self.isNotZero
    }
    
    @inlinable
    func isDivisible(by other: Self) -> Bool {
        return other.isNotZero
    }
    
}

public extension DivNumberTrait where Self : BinaryInteger & ZeroTrait {
    
    @inlinable
    var reciprocal: Self? {
        guard self.isInvertible == true else { return nil }
        return 1 / self
    }
    
    @inlinable
    func isFactor< Other : DivNumberTrait & ZeroTrait >(of other: Other) -> Bool {
        return other.truncatingRemainder(dividingBy: self).isZero
    }
    
}

public extension DivNumberTrait where Self : BinaryFloatingPoint & ZeroTrait {
    
    @inlinable
    var reciprocal: Self? {
        guard self.isInvertible == true else { return nil }
        return 1 / self
    }
    
    @inlinable
    func isFactor< Other : DivNumberTrait & ZeroTrait >(of other: Other) -> Bool {
        return other.truncatingRemainder(dividingBy: self).isZero
    }
    
}
