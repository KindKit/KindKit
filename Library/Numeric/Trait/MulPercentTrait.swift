//
//  KindKit
//

import KindCore

public protocol MulPercentTrait {
	
    func multiplying(by other: Percent) -> Self
    
}

public extension MulPercentTrait {
    
    @inlinable
    static func * (lhs: Self, rhs: Percent) -> Self {
        return lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func * (lhs: Percent, rhs: Self) -> Self {
        return rhs.multiplying(by: lhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Percent) {
        lhs = lhs.multiplying(by: rhs)
    }
    
}

public extension MulPercentTrait where Self : MulNumberTrait {
    
    @inlinable
    func multiplying(by other: Percent) -> Self {
        return self.multiplying(by: other.value)
    }
    
}
