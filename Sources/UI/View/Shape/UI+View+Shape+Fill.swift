//
//  KindKit
//

import Foundation

public extension UI.View.Shape {
    
    struct Fill : Equatable {
        
        public let rule: Graphics.FillRule
        public let color: UI.Color
        
        public init(
            rule: Graphics.FillRule = .nonZero,
            color: UI.Color
        ) {
            self.rule = rule
            self.color = color
        }
        
    }
    
}

extension UI.View.Shape.Fill : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            rule: self.rule,
            color: self.color.lerp(to.color, progress: progress)
        )
    }
    
}
