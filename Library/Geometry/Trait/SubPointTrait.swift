//
//  KindKit
//

import KindNumeric

public protocol SubPointTrait {
    
    func subtracting(this point: Point) -> Self
    
}

public extension SubPointTrait {
    
    @inlinable
    static func - (lhs: Self, rhs: Point) -> Self {
        return lhs.subtracting(this: rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Point) {
        lhs = lhs.subtracting(this: rhs)
    }
    
}
