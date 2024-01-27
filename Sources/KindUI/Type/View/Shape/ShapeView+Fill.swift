//
//  KindKit
//

import KindGraphics
import KindMath
import KindMonadicMacro

public extension ShapeView {
    
    @KindMonadic
    struct Fill : Equatable {
        
        @KindMonadicProperty
        public let rule: FillRule
        
        @KindMonadicProperty
        public let color: Color
        
        public init(
            rule: FillRule = .nonZero,
            color: Color
        ) {
            self.rule = rule
            self.color = color
        }
        
    }
    
}

extension ShapeView.Fill : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            rule: self.rule,
            color: self.color.lerp(to.color, progress: progress)
        )
    }
    
}
