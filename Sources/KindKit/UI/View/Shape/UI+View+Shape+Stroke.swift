//
//  KindKit
//

import Foundation

public extension UI.View.Shape {
    
    struct Stroke : Equatable {
        
        public let color: UI.Color
        public let start: Double
        public let end: Double
        
        public init(
            color: UI.Color,
            start: Double = 0,
            end: Double = 1
        ) {
            self.color = color
            self.start = start
            self.end = end
        }
        
    }
    
}

extension UI.View.Shape.Stroke : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            color: self.color.lerp(to.color, progress: progress),
            start: self.start.lerp(to.start, progress: progress),
            end: self.end.lerp(to.end, progress: progress)
        )
    }
    
}
