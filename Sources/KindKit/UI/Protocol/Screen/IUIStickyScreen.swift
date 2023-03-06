//
//  KindKit
//

import Foundation

public protocol IUIStickyScreen : IUIScreen {
    
    var sticky: UI.View.Bar { get }
    var stickyVisibility: Double { get }
    var stickyHidden: Bool { get }
    
}

public extension IUIStickyScreen {
    
    var stickyVisibility: Double {
        return 1
    }
    
    var stickyHidden: Bool {
        return false
    }
    
}

public extension IUIStickyScreen {
    
    @inlinable
    var stickyContainer: IUIStickyContainer? {
        return self.container as? IUIStickyContainer
    }
    
    @discardableResult
    func stickyUpdate(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.stickyContainer else { return false }
        container.updateSticky(animated: animated, completion: completion)
        return true
    }
    
}
