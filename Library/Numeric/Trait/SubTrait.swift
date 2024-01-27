//
//  KindKit
//

public protocol SubTrait {
	
    func subtracting(this other: Self) -> Self
    
}

public extension SubTrait {
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return lhs.subtracting(this: rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs.subtracting(this: rhs)
    }
    
}

public extension SubTrait where Self : AdditiveArithmetic {
    
    func subtracting(this other: Self) -> Self {
        return self - other
    }
    
}
