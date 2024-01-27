//
//  KindKit
//

import KindCore

public protocol MulNumberTrait {
	
    func multiplying< Other : BinaryInteger >(by other: Other) -> Self
    
    func multiplying< Other : BinaryFloatingPoint >(by other: Other) -> Self
    
}

public extension MulNumberTrait {
    
    @inlinable
    static func * < Other : BinaryInteger >(lhs: Self, rhs: Other) -> Self {
        return lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func * < Other : BinaryInteger >(lhs: Other, rhs: Self) -> Self {
        return rhs.multiplying(by: lhs)
    }
    
    @inlinable
    static func * < Other : BinaryFloatingPoint >(lhs: Self, rhs: Other) -> Self {
        return lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func * < Other : BinaryFloatingPoint >(lhs: Other, rhs: Self) -> Self {
        return rhs.multiplying(by: lhs)
    }
    
    @inlinable
    static func *= < Other : BinaryInteger >(lhs: inout Self, rhs: Other) {
        lhs = lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func *= < Other : BinaryFloatingPoint >(lhs: inout Self, rhs: Other) {
        lhs = lhs.multiplying(by: rhs)
    }
    
}

public extension MulNumberTrait where Self : FromNumberTrait & MulTrait {
    
    @inlinable
    func multiplying< Other : BinaryInteger >(by other: Other) -> Self {
        return self.multiplying(by: Self.init(other))
    }
    
    @inlinable
    func multiplying< Other : BinaryFloatingPoint >(by other: Other) -> Self {
        return self.multiplying(by: Self.init(other))
    }
    
}

public extension MulTrait where Self : Equatable & DivNumberTrait & ZeroTrait {
    
    @inlinable
    func isMultiple< Input : BinaryInteger & Equatable & ZeroTrait >(of other: Input) -> Bool {
        guard self.isNotZero && other.isNotZero else { return true }
        return self.truncatingRemainder(dividingBy: other).isZero
    }
    
    @inlinable
    func isMultiple< Input : BinaryFloatingPoint & Equatable & ZeroTrait >(of other: Input) -> Bool {
        guard self.isNotZero && other.isNotZero else { return true }
        return self.truncatingRemainder(dividingBy: other).isZero
    }
    
}
