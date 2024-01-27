//
//  KindKit
//

import KindGraphics
import KindMath
import KindMonadicMacro

extension ShapeView {
    
    @KindMonadic
    public struct Stroke : Equatable {
    
        @KindMonadicProperty
        public let color: Color
        
        @KindMonadicProperty
        public let start: Double
        
        @KindMonadicProperty
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
