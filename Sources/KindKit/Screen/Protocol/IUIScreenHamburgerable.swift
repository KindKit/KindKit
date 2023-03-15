//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenHamburgerable")
public typealias IUIScreenHamburgerable = IScreenHamburgerable

public protocol IScreenHamburgerable : AnyObject {
    
    var hamburgerSize: Double { get }
    var hamburgerLimit: Double { get }
    
}

public extension IScreenHamburgerable {
    
    var hamburgerSize: Double {
        return 240
    }
    
    var hamburgerLimit: Double {
        return 120
    }
    
}

public extension IScreenHamburgerable where Self : IScreen {
    
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
