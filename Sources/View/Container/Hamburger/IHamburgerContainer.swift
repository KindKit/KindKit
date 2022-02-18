//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IHamburgerContainer : IContainer, IContainerParentable {
    
    var contentContainer: IHamburgerContentContainer { set get }
    var isShowedLeadingContainer: Bool { get }
    var leadingContainer: IHamburgerMenuContainer? { set get }
    var isShowedTrailingContainer: Bool { get }
    var trailingContainer: IHamburgerMenuContainer? { set get }
    var animationVelocity: Float { set get }
    
    func showLeadingContainer(animated: Bool, completion: (() -> Void)?)
    func hideLeadingContainer(animated: Bool, completion: (() -> Void)?)
    
    func showTrailingContainer(animated: Bool, completion: (() -> Void)?)
    func hideTrailingContainer(animated: Bool, completion: (() -> Void)?)

}

public extension IHamburgerContainer {
    
    @inlinable
    func showLeadingContainer(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.showLeadingContainer(animated: animated, completion: completion)
    }
    
    @inlinable
    func hideLeadingContainer(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.hideLeadingContainer(animated: animated, completion: completion)
    }
    
    @inlinable
    func showTrailingContainer(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.showTrailingContainer(animated: animated, completion: completion)
    }
    
    @inlinable
    func hideTrailingContainer(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.hideTrailingContainer(animated: animated, completion: completion)
    }
    
    func set(leadingContainer: IHamburgerMenuContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated == true {
            if self.isShowedLeadingContainer == true {
                self.hideLeadingContainer(animated: animated, completion: { [weak self] in
                    guard let self = self else { return }
                    self.leadingContainer = leadingContainer
                    self.showLeadingContainer(animated: animated, completion: completion)
                })
            } else {
                self.leadingContainer = leadingContainer
            }
        } else {
            self.leadingContainer = leadingContainer
        }
    }
    
    func set(trailingContainer: IHamburgerMenuContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated == true {
            if self.isShowedTrailingContainer == true {
                self.hideTrailingContainer(animated: animated, completion: { [weak self] in
                    guard let self = self else { return }
                    self.trailingContainer = trailingContainer
                    self.showTrailingContainer(animated: animated, completion: completion)
                })
            } else {
                self.trailingContainer = trailingContainer
            }
        } else {
            self.trailingContainer = trailingContainer
        }
    }
    
}

public protocol IHamburgerContentContainer : IContainer, IContainerParentable {
    
    var hamburgerContainer: IHamburgerContainer? { get }

}

public extension IHamburgerContentContainer {
    
    @inlinable
    var hamburgerContainer: IHamburgerContainer? {
        return self.parent as? IHamburgerContainer
    }
    
}

public protocol IHamburgerMenuContainer : IHamburgerContentContainer {
    
    var hamburgerSize: Float { get }
    var hamburgerLimit: Float { get }
    
}
