//
//  KindKit
//

import KindGeometry

extension Border : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            width: self.width.lerp(to.width, by: progress),
            color: self.color.lerp(to.color, by: progress)
        )
    }
    
}
