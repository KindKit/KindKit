//
//  KindKit
//

import KindCore

public extension Comparable where Self : DivNumberTrait & ZeroTrait {
    
    @inlinable
    var isEven: Bool {
        return self.truncatingRemainder(dividingBy: 2).isZero
    }
    
    @inlinable
    var isOdd: Bool {
        return self.truncatingRemainder(dividingBy: 2).isNotZero
    }
    
}
