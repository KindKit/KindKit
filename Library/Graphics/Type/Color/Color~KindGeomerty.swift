//
//  KindKit
//

import KindGeometry

extension Color : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(self.pixel.lerp(to.pixel, by: progress))
    }
    
}
