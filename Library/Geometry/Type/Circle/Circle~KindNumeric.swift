//
//  KindKit
//

import KindNumeric

extension Circle : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            origin: self.origin.lerp(to.origin, by: progress),
            radius: self.radius.lerp(to.radius, by: progress)
        )
    }
    
}

