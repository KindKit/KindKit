//
//  KindKit
//

import KindCore

public protocol MulExTrait {
    
    associatedtype Multiplier
    associatedtype Product
	
    func multiplying(by other: Multiplier) -> Product
    
}

public extension MulExTrait {
    
    @inlinable
    static func * (lhs: Self, rhs: Multiplier) -> Product {
        return lhs.multiplying(by: rhs)
    }
    
}
