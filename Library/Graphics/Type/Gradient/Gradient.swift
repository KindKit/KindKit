//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct Gradient {
    
    @MonadicField
    public let mode: Mode
    
    @MonadicField
    public let points: [Point]
    
    @MonadicField
    public let start: KindGraphics.Point
    
    @MonadicField
    public let end: KindGraphics.Point
    
    public init(
        mode: Mode = .axial,
        points: [Point] = [],
        start: KindGraphics.Point = .init(x: 0, y: 0),
        end: KindGraphics.Point = .init(x: 0, y: 1)
    ) {
        self.mode = mode
        self.points = points
        self.start = start
        self.end = end
    }
    
}

extension Gradient : Hashable {
}

extension Gradient : Equatable {
}

extension Gradient : Sendable {
}

public extension Gradient {
    
    @inlinable
    var isOpaque: Bool {
        for point in self.points {
            if point.color.isOpaque == false {
                return false
            }
        }
        return true
    }
    
}
