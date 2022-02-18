//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore

extension UIScreen {
    
    var animationVelocity: Float {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return Float(max(self.bounds.width, self.bounds.height) * 2.2)
        case .pad: return Float(max(self.bounds.width, self.bounds.height) * 2.5)
        default: return 100
        }
    }
    
}

#endif
