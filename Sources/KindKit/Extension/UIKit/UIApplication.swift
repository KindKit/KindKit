//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIApplication {
    
    @inlinable
    @available(iOS 13.0, *)
    var kk_windowScenes: [UIWindowScene] {
        return self.connectedScenes.compactMap({
            return $0 as? UIWindowScene
        })
    }
    
    @inlinable
    func kk_endEditing(_ force: Bool) {
        if let window = self.keyWindow {
            window.endEditing(force)
        }
    }
    
}

#endif
