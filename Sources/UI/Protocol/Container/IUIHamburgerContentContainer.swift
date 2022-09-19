//
//  KindKit
//

import Foundation

public protocol IUIHamburgerContentContainer : IUIContainer, IUIContainerParentable {
    
    var hamburgerContainer: IUIHamburgerContainer? { get }

}

public extension IUIHamburgerContentContainer {
    
    @inlinable
    var hamburgerContainer: IUIHamburgerContainer? {
        return self.parent as? IUIHamburgerContainer
    }
    
}

public protocol IHamburgerMenuContainer : IUIHamburgerContentContainer {
    
    var hamburgerSize: Float { get }
    var hamburgerLimit: Float { get }
    
}
