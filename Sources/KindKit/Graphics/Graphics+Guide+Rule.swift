//
//  KindKit
//

import Foundation

public extension Graphics.Guide {
    
    final class Rule : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var size: Distance
        public var snap: Distance
        
        public init(
            isEnabled: Bool = true,
            size: Distance,
            snap: Distance
        ) {
            self.isEnabled = isEnabled
            self.size = size
            self.snap = snap
        }
        
        public func guide(_ value: Distance) -> Distance {
            guard self.isEnabled == true else { return value }
            let n = value.abs
            let b = (n / self.size).roundNearest
            let g = b * self.size
            if n >= g - self.snap && n <= g + self.snap {
                if value < .zero {
                    return -g
                } else {
                    return g
                }
            }
            return value
        }
        
    }
    
}

public extension Graphics.Guide.Rule {
    
    @inlinable
    @discardableResult
    func size(_ value: Distance) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> Distance) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> Distance) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: Distance) -> Self {
        self.snap = value
        return self
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: () -> Distance) -> Self {
        return self.snap(value())
    }

    @inlinable
    @discardableResult
    func snap(_ value: (Self) -> Distance) -> Self {
        return self.snap(value(self))
    }
    
}
