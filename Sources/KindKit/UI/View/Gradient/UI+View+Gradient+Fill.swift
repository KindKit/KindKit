//
//  KindKit
//

import Foundation

public extension UI.View.Gradient {
    
    struct Fill : Equatable {
        
        public let mode: Mode
        public let points: [Point]
        public let start: KindKit.Point
        public let end: KindKit.Point
        
        public init(
            mode: Mode,
            points: [Point],
            start: KindKit.Point,
            end: KindKit.Point
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
