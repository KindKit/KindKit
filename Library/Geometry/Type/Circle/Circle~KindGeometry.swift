//
//  KindKit
//

import KindNumeric

extension Circle : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(
            origin: self.origin.multiplying(by: matrix),
            radius: self.radius.multiplying(by: matrix)
        )
    }
    
}
