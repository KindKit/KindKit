//
//  KindKit
//

import KindUI

public protocol IStickyScreen : IScreen {
    
    var sticky: BarView { get }
    var stickyVisibility: Double { get }
    var stickyHidden: Bool { get }
    
}

public extension IStickyScreen {
    
    var stickyVisibility: Double {
        return 1
    }
    
    var stickyHidden: Bool {
        return false
    }
    
}

public extension IStickyScreen {
    
    @inlinable
    var stickyContainer: IStickyContainer? {
        return self.container as? IStickyContainer
    }
    
    @discardableResult
    func stickyUpdate(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.stickyContainer else { return false }
        container.updateSticky(animated: animated, completion: completion)
        return true
    }
    
}
