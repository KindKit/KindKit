//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.CornerRadius.Edge {
    
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
