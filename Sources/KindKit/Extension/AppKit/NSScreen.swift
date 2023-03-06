//
//  KindKit
//

#if os(macOS)

import AppKit

#warning("Need impl kk_diagonalInInches: Double")
#warning("Need impl kk_animationVelocity: Double")
#warning("Need impl kk_pixelPerInch: Double")
public extension NSScreen {
    
    static let kk_animationVelocity: Double = {
        return 2000
    }()
    
}

#endif
