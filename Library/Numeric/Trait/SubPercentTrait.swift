//
//  KindKit
//

import KindCore

public protocol SubPercentTrait {
	
    func subtracting(by other: Percent) -> Self
    
}

public extension SubPercentTrait {
    
    @inlinable
    static func - (lhs: Self, rhs: Percent) -> Self {
        return lhs.subtracting(by: rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Percent) {
        lhs = lhs.subtracting(by: rhs)
    }
    
}

public extension SubPercentTrait where Self : SubTrait & MulPercentTrait {
    
    @inlinable
    func subtracting(by other: Percent) -> Self {
        return self.subtracting(this: self.multiplying(by: other))
    }
    
}
