//
//  KindKit
//

import KindCore

public protocol AddPercentTrait {
	
    func adding(by percent: Percent) -> Self
    
}

public extension AddPercentTrait {
    
    @inlinable
    static func + (lhs: Self, rhs: Percent) -> Self {
        return lhs.adding(by: rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Percent) {
        lhs = lhs.adding(by: rhs)
    }
    
}

public extension AddPercentTrait where Self : AddTrait & MulPercentTrait {
    
    @inlinable
    func adding(by percent: Percent) -> Self {
        return self.adding(on: self.multiplying(by: percent))
    }
    
}
