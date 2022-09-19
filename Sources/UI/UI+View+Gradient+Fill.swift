//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Gradient {
    
    struct Fill {
        
        public let mode: Mode
        public let points: [UI.View.Gradient.Fill.Point]
        public let start: PointFloat
        public let end: PointFloat
        
        public init(
            mode: Mode,
            points: [UI.View.Gradient.Fill.Point],
            start: PointFloat,
            end: PointFloat
        ) {
            self.mode = mode
            self.points = points
            self.start = start
            self.end = end
        }
        
    }
    
}

public extension UI.View.Gradient.Fill {
    
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

#endif
