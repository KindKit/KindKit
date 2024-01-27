//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIApplication {
    
    @inlinable
    @available(iOS 13.0, *)
    final var kk_windowScenes: [UIWindowScene] {
        return self.connectedScenes.compactMap({
            return $0 as? UIWindowScene
        })
    }
    
    @inlinable
    final var kk_windows: [UIWindow] {
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
    final var kk_keyWindows: [UIWindow] {
        return self.kk_windows.filter({ $0.isKeyWindow })
    }
    
    @inlinable
    final var kk_keyWindow: UIWindow? {
        return self.kk_keyWindows.first
    }
    
    @inlinable
    final var kk_firstResponder: UIView? {
        guard let keyWindow = self.kk_keyWindow else { return nil }
        return keyWindow.kk_firstResponder
    }

    @inlinable
    final func kk_endEditing(_ force: Bool) {
        for window in self.kk_keyWindows {
            window.endEditing(force)
        }
    }
    
}

#endif
