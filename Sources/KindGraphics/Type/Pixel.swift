//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct Pixel : Equatable {
    
    @KindMonadicProperty
    public let r: Double
    
    @KindMonadicProperty
    public let g: Double
    
    @KindMonadicProperty
    public let b: Double
    
    @KindMonadicProperty
    public let a: Double
    
    public init(
        r: Double,
        g: Double,
        b: Double,
        a: Double
    ) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
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

extension Pixel : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            r: self.r.lerp(to.r, progress: progress),
            g: self.g.lerp(to.g, progress: progress),
            b: self.b.lerp(to.b, progress: progress),
            a: self.a.lerp(to.a, progress: progress)
        )
    }
    
}
