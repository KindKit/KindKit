//
//  KindKit
//

import KindNumeric

extension Distance : MulMatrix3Trait {

    @inlinable
    public func multiplying(by other: Matrix3) -> Self {
        let point = Point(x: self.value, y: .zero)
        return point.multiplying(by: other).length
    }
    
}
