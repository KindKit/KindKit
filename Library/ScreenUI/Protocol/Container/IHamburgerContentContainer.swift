//
//  KindKit
//

public protocol IHamburgerContentContainer : IContainer, IContainerParentable {
    
    var hamburgerContainer: IHamburgerContainer? { get }

}

public extension IHamburgerContentContainer {
    
    @inlinable
    var hamburgerContainer: IHamburgerContainer? {
        return self.parent as? IHamburgerContainer
    }
    
}
