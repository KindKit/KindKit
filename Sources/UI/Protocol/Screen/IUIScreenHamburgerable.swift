//
//  KindKit
//

import Foundation

public protocol IUIScreenHamburgerable : AnyObject {
    
    var hamburgerSize: Double { get }
    var hamburgerLimit: Double { get }
    
}

public extension IUIScreenHamburgerable {
    
    var hamburgerSize: Double {
        return 240
    }
    
    var hamburgerLimit: Double {
        return 120
    }
    
}

public extension IUIScreenHamburgerable where Self : IUIScreen {
    
    @inlinable
    var hamburgerContentContainer: IUIHamburgerContentContainer? {
        guard let contentContainer = self.container as? IUIHamburgerContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var hamburgerContainer: IUIHamburgerContainer? {
        return self.hamburgerContentContainer?.hamburgerContainer
    }
    
}
