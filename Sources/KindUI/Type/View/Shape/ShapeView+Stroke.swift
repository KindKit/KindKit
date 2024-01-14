//
//  KindKit
//

import KindGraphics
import KindMath

extension ShapeView {
    
    public struct Stroke : Equatable {
        
        public let color: Color
        public let start: Double
        public let end: Double
        
        public init(
            color: Color,
            start: Double = 0,
            end: Double = 1
        ) {
            self.color = color
            self.start = start
            self.end = end
        }
        
    }
    
}

extension ShapeView.Stroke : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            color: self.color.lerp(to.color, progress: progress),
            start: self.start.lerp(to.start, progress: progress),
            end: self.end.lerp(to.end, progress: progress)
        )
    }
    
}
