//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStickyScreen : IScreen {
    
    associatedtype AssociatedStickyBar : IBarView
    
    var stickyView: AssociatedStickyBar { get }
    var stickyVisibility: Float { get }
    var stickyHidden: Bool { get }
    
}

public extension IStickyScreen {
    
    var stickyVisibility: Float {
        return 1
    }
    
    var stickyHidden: Bool {
        return false
    }
    
    @inlinable
    var stickyContainer: IStickyContainer? {
        return self.container as? IStickyContainer
    }
    
    func updateSticky(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.stickyContainer?.updateOverlay(animated: animated, completion: completion)
    }
    
}
