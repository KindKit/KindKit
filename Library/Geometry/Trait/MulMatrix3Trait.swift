//
//  KindKit
//

import KindNumeric

public protocol MulMatrix3Trait {
    
    func multiplying(by matrix: Matrix3) -> Self
    
}

public extension MulMatrix3Trait {
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix3) -> Self {
        return lhs.multiplying(by: rhs)
    }
    
    @inlinable
    static func * (lhs: Matrix3, rhs: Self) -> Self {
        return rhs.multiplying(by: lhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3) {
        lhs = lhs.multiplying(by: rhs)
    }
    
}
