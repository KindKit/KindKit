//
//  KindKit
//

import KindNumeric

public protocol AddPointTrait {
    
    func adding(on point: Point) -> Self
    
}

public extension AddPointTrait {
    
    @inlinable
    static func + (lhs: Self, rhs: Point) -> Self {
        return lhs.adding(on: rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Point) {
        lhs = lhs.adding(on: rhs)
    }
    
}
