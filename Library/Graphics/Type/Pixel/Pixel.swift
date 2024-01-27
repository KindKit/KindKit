//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct Pixel {
    
    @MonadicField
    public let r: Double
    
    @MonadicField
    public let g: Double
    
    @MonadicField
    public let b: Double
    
    @MonadicField
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
            r: .random(in: r),
            g: .random(in: g),
            b: .random(in: b),
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
            r: .random(in: r),
            g: .random(in: g),
            b: .random(in: b),
            a: .random(in: a)
        )
    }
    
}

extension Pixel : Hashable {
}

extension Pixel : Equatable {
}

extension Pixel : Sendable {
}
