//
//  KindKit
//

import KindGeometry

extension Pixel : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            r: self.r.lerp(to.r, by: progress),
            g: self.g.lerp(to.g, by: progress),
            b: self.b.lerp(to.b, by: progress),
            a: self.a.lerp(to.a, by: progress)
        )
    }
    
}
