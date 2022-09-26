//
//  KindKit
//

import Foundation

public protocol IUIStickyScreen : IUIScreen {
    
    var sticky: UI.View.Bar { get }
    var stickyVisibility: Float { get }
    var stickyHidden: Bool { get }
    
}

public extension IUIStickyScreen {
    
    var stickyVisibility: Float {
        return 1
    }
    
    var stickyHidden: Bool {
        return false
    }
    
    @inlinable
    var stickyContainer: IUIStickyContainer? {
        return self.container as? IUIStickyContainer
    }
    
    func updateSticky(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.stickyContainer?.updateOverlay(animated: animated, completion: completion)
    }
    
}
