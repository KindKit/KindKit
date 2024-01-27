//
//  KindKit
//

import KindMath
import KindMonadicMacro

extension GradientView {
    
    @KindMonadic
    public struct Fill : Equatable {
        
        @KindMonadicProperty
        public let mode: Mode
        
        @KindMonadicProperty
        public let points: [GradientView.Fill.Point]
        
        @KindMonadicProperty
        public let start: KindMath.Point
        
        @KindMonadicProperty
        public let end: KindMath.Point
        
        public init(
            mode: Mode,
            points: [GradientView.Fill.Point],
            start: KindMath.Point,
            end: KindMath.Point
        ) {
            self.mode = mode
            self.points = points
            self.start = start
            self.end = end
        }
        
    }
    
}

public extension GradientView.Fill {
    
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
