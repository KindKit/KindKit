//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenHamburgerable : AnyObject {
    
    var hamburgerSize: Float { get }
    var hamburgerLimit: Float { get }
    
}

public extension IScreenHamburgerable {
    
    var hamburgerSize: Float {
        return 240
    }
    
    var hamburgerLimit: Float {
        return 120
    }
    
}

public extension IScreenHamburgerable where Self : IScreen {
    
    @inlinable
    var hamburgerContentContainer: IHamburgerContentContainer? {
        guard let contentContainer = self.container as? IHamburgerContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var hamburgerContainer: IHamburgerContainer? {
        return self.hamburgerContentContainer?.hamburgerContainer
    }
    
}
