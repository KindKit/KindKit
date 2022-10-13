//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeColor = NSColor

public extension NSColor {
    
    @inlinable
    var kk_isOpaque: Bool {
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

#endif
