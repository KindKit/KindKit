//
//  KindKit
//

import KindGraphics
import KindMath
import KindMonadicMacro

public extension ShapeView {
    
    @KindMonadic
    struct Line : Equatable {
    
        @KindMonadicProperty
        public let width: Double
        
        @KindMonadicProperty
        public let cap: LineCap
        
        @KindMonadicProperty
        public let join: LineJoin
        
        @KindMonadicProperty
        public let dash: LineDash?
        
        public init(
            width: Double = 1,
            cap: LineCap = .butt,
            join: LineJoin = .miter(10),
            dash: LineDash? = nil
        ) {
            self.width = width
            self.cap = cap
            self.join = join
            self.dash = dash
        }
        
    }
    
}

extension ShapeView.Line : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            width: self.width.lerp(to.width, progress: progress),
            cap: self.cap,
            join: self.join,
            dash: self.dash
        )
    }
    
}
