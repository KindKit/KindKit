//
//  KindKit
//

public protocol AddTrait {
	
    func adding(on other: Self) -> Self
    
}

public extension AddTrait {
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return lhs.adding(on: rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs.adding(on: rhs)
    }
    
}

public extension AddTrait where Self : AdditiveArithmetic {
    
    func adding(on other: Self) -> Self {
        return self + other
    }
    
}
