//
//  KindKit
//

#if os(macOS)

import AppKit

#warning("Need impl kk_diagonalInInches: Float")
#warning("Need impl kk_animationVelocity: Float")
#warning("Need impl kk_pixelPerInch: Float")
public extension NSScreen {
    
    static let kk_animationVelocity: Float = {
        return 2000
    }()
    
}

#endif
