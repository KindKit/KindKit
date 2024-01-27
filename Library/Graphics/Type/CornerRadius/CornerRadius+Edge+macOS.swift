//
//  KindKit
//

#if os(macOS)

import AppKit

public extension CornerRadius.Edge {
    
    var caCornerMask: CACornerMask {
        var caCornerMask: CACornerMask = []
        if self.contains(.topLeft) == true {
            caCornerMask.insert(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) == true {
            caCornerMask.insert(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomLeft) == true {
            caCornerMask.insert(.layerMinXMaxYCorner)
        }
        if self.contains(.bottomRight) == true {
            caCornerMask.insert(.layerMaxXMaxYCorner)
        }
        return caCornerMask
    }
    
}

#endif
