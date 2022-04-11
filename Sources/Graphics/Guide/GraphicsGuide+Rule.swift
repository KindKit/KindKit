//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsGuide {
    
    class Rule {
        
        public var size: Float
        public var snap: Float
        
        public init(
            size: Float,
            snap: Float
        ) {
            self.size = size
            self.snap = snap
        }
        
    }
    
}

extension GraphicsGuide.Rule : IGraphicsRuleGuide {
    
    public func guide(_ value: Float) -> Float? {
        let n = value.abs
        let b = (n / self.size).roundNearest
        let g = b * self.size
        if n >= g - self.snap && n <= g + self.snap {
            if value < 0 {
                return -g
            } else {
                return g
            }
        }
        return nil
    }
    
}
