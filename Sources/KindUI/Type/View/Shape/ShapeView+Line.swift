//
//  KindKit
//

import KindGraphics
import KindMath

public extension ShapeView {
    
    struct Line : Equatable {
        
        public let width: Double
        public let cap: LineCap
        public let join: LineJoin
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
