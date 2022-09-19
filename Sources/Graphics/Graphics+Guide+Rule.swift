//
//  KindKit
//

import Foundation

public extension Graphics.Guide {
    
    final class Rule : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var size: Float
        public var snap: Float
        
        public init(
            isEnabled: Bool = true,
            size: Float,
            snap: Float
        ) {
            self.isEnabled = isEnabled
            self.size = size
            self.snap = snap
        }
        
    }
    
}

extension Graphics.Guide.Rule : IGraphicsRuleGuide {
    
    public func guide(_ value: Float) -> Float? {
        guard self.isEnabled == true else { return nil }
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
