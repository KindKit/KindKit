//
//  KindKit
//

import KindGraphics
import KindGeometry
import KindMonadicMacro

public extension ShapeView {
    
    @Monadic
    struct Fill : Equatable {
        
        @MonadicField
        public let rule: FillRule
        
        @MonadicField
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
