//
//  KindKit
//

import KindGeometry

public struct Color {
    
    public var handle: HandleColor
    
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
        r: Range< Coordinate >,
        g: Range< Coordinate >,
        b: Range< Coordinate >,
        a: Coordinate = 1
    ) {
        self.init(
            r: Coordinate.random(in: r),
            g: Coordinate.random(in: g),
            b: Coordinate.random(in: b),
            a: a
        )
    }
    
    public init(
        r: Range< Coordinate >,
        g: Range< Coordinate >,
        b: Range< Coordinate >,
        a: Range< Coordinate >
    ) {
        self.init(
            r: Coordinate.random(in: r),
            g: Coordinate.random(in: g),
            b: Coordinate.random(in: b),
            a: Coordinate.random(in: a)
        )
    }
    
}

extension Color : Hashable {
}

extension Color : Equatable {
}

extension Color : Sendable {
}

public extension Color {
    
    static func hex(rgb: UInt32) -> Self {
        return .init(rgb: rgb)
    }
    
    static func hex(rgba: UInt32) -> Self {
        return .init(rgba: rgba)
    }
    
}
