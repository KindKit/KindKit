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
    var kk_windows: [UIWindow] {
        if #available(iOS 13.0, *) {
            var windows: [UIWindow] = []
            for windowScene in self.kk_windowScenes {
                windows.append(contentsOf: windowScene.windows)
            }
            return windows
        }
        return self.windows
    }

    @inlinable
    var kk_keyWindows: [UIWindow] {
        return self.kk_windows.filter({ $0.isKeyWindow })
    }
    
    @inlinable
    var kk_keyWindow: UIWindow? {
        return self.kk_keyWindows.first
    }

    @inlinable
    func kk_endEditing(_ force: Bool) {
        for window in self.kk_keyWindows {
            window.endEditing(force)
        }
    }
    
}

#endif
