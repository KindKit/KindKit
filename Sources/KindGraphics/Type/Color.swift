//
//  KindKit
//

import KindMath

public struct Color : Equatable, Hashable {
    
    public var native: NativeColor
    
    public init(
        _ pixel: Pixel
    ) {
        self.init(
            r: pixel.r,
            g: pixel.g,
            b: pixel.b,
            a: pixel.a
        )
    }
    
    public init(
        r: Range< Double >,
        g: Range< Double >,
        b: Range< Double >,
        a: Double = 1
    ) {
        self.init(
            r: Double.random(in: r),
            g: Double.random(in: g),
            b: Double.random(in: b),
            a: a
        )
    }
    
    public init(
        r: Range< Double >,
        g: Range< Double >,
        b: Range< Double >,
        a: Range< Double >
    ) {
        self.init(
            r: Double.random(in: r),
            g: Double.random(in: g),
            b: Double.random(in: b),
            a: Double.random(in: a)
        )
    }
    
}

extension Color : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(self.pixel.lerp(to.pixel, progress: progress))
    }
    
}
