//
//  KindKitView
//

#if os(iOS)

import UIKit

extension UIColor {
    
    @inlinable
    public var isOpaque: Bool {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            if (1 - a) > CGFloat.leastNonzeroMagnitude {
                return false
            }
            return true
        }
    }
    
}

#endif
