//
//  KindKit
//

import Foundation

public extension Graphics.Guide {
    
    final class Rule : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var size: Double
        public var snap: Double
        
        public init(
            isEnabled: Bool = true,
            size: Double,
            snap: Double
        ) {
            self.isEnabled = isEnabled
            self.size = size
            self.snap = snap
        }
        
    }
    
}

extension Graphics.Guide.Rule : IGraphicsRuleGuide {
    
    public func guide(_ value: Double) -> Double? {
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
