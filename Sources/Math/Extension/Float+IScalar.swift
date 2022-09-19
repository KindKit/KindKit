//
//  KindKit
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

extension Float : IScalar {
    
    @inlinable
    public static var epsilon: Self {
        return .ulpOfOne
    }
    
    @inlinable
    public var double: Double {
        return Double(self)
    }
    
    #if canImport(CoreGraphics)

    @inlinable
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }

    #endif
    
    @inlinable
    public var roundUp: Self {
        return self.rounded(.up)
    }
    
    @inlinable
    public var roundDown: Self {
        return self.rounded(.down)
    }
    
    @inlinable
    public var roundNearest: Self {
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    @inlinable
    public var abs: Self {
        return Swift.abs(self)
    }
    
    @inlinable
    public var sqrt: Self {
        return Foundation.sqrt(self)
    }
    
    @inlinable
    public var sin: Self {
        return Foundation.sin(self)
    }
    
    @inlinable
    public var asin: Self {
        return Foundation.asin(self)
    }
    
    @inlinable
    public var cos: Self {
        return Foundation.cos(self)
    }
    
    @inlinable
    public var acos: Self {
        return Foundation.acos(self)
    }
    
    @inlinable
    public func atan2(_ other: Self) -> Self {
        return Foundation.atan2(self, other)
    }

}
