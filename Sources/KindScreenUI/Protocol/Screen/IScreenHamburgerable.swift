//
//  KindKit
//

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
    var hamburgerContentContainer: IHamburgerContentContainer? {
        guard let contentContainer = self.container as? IHamburgerContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var hamburgerContainer: IHamburgerContainer? {
        return self.hamburgerContentContainer?.hamburgerContainer
    }
    
}
