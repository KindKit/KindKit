//
//  KindKit
//

import KindCore

public protocol MulTrait {
	
    func doubled() -> Self
    
    func multiplying(by other: Self) -> Self
    
}

public extension MulTrait {
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs.multiplying(by: rhs)
    }
    
}

public extension MulTrait where Self : Equatable & DivTrait & ZeroTrait {
    
    @inlinable
    func isMultiple(of other: Self) -> Bool {
        guard self.isNotZero && other.isNotZero else { return true }
        return self.truncatingRemainder(dividingBy: other).isZero
    }
    
}

public extension MulTrait where Self : BinaryInteger {
    
    @inlinable
    func doubled() -> Self {
        return self * 2
    }
    
    @inlinable
    func multiplying(by other: Self) -> Self {
        return self * other
    }
    
}

public extension MulTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    func doubled() -> Self {
        return self * 2
    }
    
    @inlinable
    func multiplying(by other: Self) -> Self {
        return self * other
    }
    
}
