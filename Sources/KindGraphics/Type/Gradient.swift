//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct Gradient : Equatable {
    
    @KindMonadicProperty
    public let mode: Mode
    
    @KindMonadicProperty
    public let points: [Point]
    
    @KindMonadicProperty
    public let start: KindMath.Point
    
    @KindMonadicProperty
    public let end: KindMath.Point
    
    public init(
        mode: Mode,
        points: [Gradient.Point],
        start: KindMath.Point,
        end: KindMath.Point
    ) {
        self.mode = mode
        self.points = points
        self.start = start
        self.end = end
    }
    
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
