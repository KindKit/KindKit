//
//  KindKit
//

import Foundation

public extension Double {
    
    @inlinable
    var roundUp: Self {
        return self.rounded(.up)
    }
    
    @inlinable
    var roundDown: Self {
        return self.rounded(.down)
    }
    
    @inlinable
    var roundNearest: Self {
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    @inlinable
    var abs: Self {
        return Swift.abs(self)
    }
    
    @inlinable
    var sqrt: Self {
        return Foundation.sqrt(self)
    }
    
    @inlinable
    var sin: Self {
        return Foundation.sin(self)
    }
    
    @inlinable
    var asin: Self {
        return Foundation.asin(self)
    }
    
    @inlinable
    var cos: Self {
        return Foundation.cos(self)
    }
    
    @inlinable
    var acos: Self {
        return Foundation.acos(self)
    }
    
    @inlinable
    func atan2(_ other: Self) -> Self {
        return Foundation.atan2(self, other)
    }
    
}

public extension Double {
    
    @inlinable
    var degreesToRadians: Self {
        return self * .pi / 180
    }
    
    @inlinable
    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
    
}

public extension Double {
    
    @inlinable
    func clamp(_ lower: Self, _ upper: Self) -> Self {
        if self < lower {
            return lower
        } else if self > upper {
            return upper
        }
        return self
    }
    
}

extension Double : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return (progress.invert.value * self) + (progress.value * to)
    }

}
