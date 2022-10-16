//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIScreen {
    
    static let kk_diagonalPerInch: Float = {
        let bounds = UIScreen.main.nativeBounds
        return Float(sqrt((bounds.width * bounds.width) + (bounds.height * bounds.height)))
    }()
    
    var kk_animationVelocity: Float {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return Float(max(self.bounds.width, self.bounds.height) * 2.2)
        case .pad: return Float(max(self.bounds.width, self.bounds.height) * 2.5)
        default: return 100
        }
    }
    
}

#endif
