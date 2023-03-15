//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIApplication {
    
    func kk_endEditing(_ force: Bool) {
        if let window = self.keyWindow {
            window.endEditing(force)
        }
    }
    
}

#endif
