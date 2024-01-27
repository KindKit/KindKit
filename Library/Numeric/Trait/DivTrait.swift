//
//  KindKit
//

import KindCore

public protocol DivTrait {
    
    func halved() -> Self
	
    func dividing(this other: Self) -> Self
    
    func remainder(dividingBy other: Self) -> Self
    
    func truncatingRemainder(dividingBy other: Self) -> Self
    
}

public extension DivTrait {
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return lhs.dividing(this: rhs)
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs.dividing(this: rhs)
    }
    
}

public extension DivTrait where Self : BinaryInteger {
    
    @inlinable
    func halved() -> Self {
        return self / 2
    }
    
    @inlinable
    func dividing(this other: Self) -> Self {
        return self / other
    }
    
    @inlinable
    func remainder(dividingBy other: Self) -> Self {
        return self % other
    }
    
    @inlinable
    func truncatingRemainder(dividingBy other: Self) -> Self {
        return self % other
    }
    
}

public extension DivTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    func halved() -> Self {
        return self / 2.0
    }
    
    @inlinable
    func dividing(this other: Self) -> Self {
        return self / other
    }
    
}
