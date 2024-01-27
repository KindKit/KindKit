//
//  KindKit
//

#if os(iOS)

import UIKit

public extension CornerRadius.Edge {
    
    var uiRectCorner: UIRectCorner {
        var uiRectCorner: UIRectCorner = []
        if self.contains(.topLeft) == true {
            uiRectCorner.insert(.topLeft)
        }
        if self.contains(.topRight) == true {
            uiRectCorner.insert(.topRight)
        }
        if self.contains(.bottomLeft) == true {
            uiRectCorner.insert(.bottomLeft)
        }
        if self.contains(.bottomRight) == true {
            uiRectCorner.insert(.bottomRight)
        }
        return uiRectCorner
    }
    
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
