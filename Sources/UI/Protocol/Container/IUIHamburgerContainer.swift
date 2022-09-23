//
//  KindKit
//

import Foundation

public protocol IUIHamburgerContainer : IUIContainer, IUIContainerParentable {
    
    var content: IUIHamburgerContentContainer { set get }
    var leading: IHamburgerMenuContainer? { set get }
    var isShowedLeading: Bool { get }
    var trailing: IHamburgerMenuContainer? { set get }
    var isShowedTrailing: Bool { get }
    var animationVelocity: Float { set get }
    
    func showLeading(animated: Bool, completion: (() -> Void)?)
    func hideLeading(animated: Bool, completion: (() -> Void)?)
    
    func showTrailing(animated: Bool, completion: (() -> Void)?)
    func hideTrailing(animated: Bool, completion: (() -> Void)?)

}

public extension IUIHamburgerContainer {
    
    @inlinable
    func showLeading(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.showLeading(animated: animated, completion: completion)
    }
    
    @inlinable
    func hideLeading(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.hideLeading(animated: animated, completion: completion)
    }
    
    @inlinable
    func showTrailing(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.showTrailing(animated: animated, completion: completion)
    }
    
    @inlinable
    func hideTrailing(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.hideTrailing(animated: animated, completion: completion)
    }
    
    func set(leading: IHamburgerMenuContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated == true {
            if self.isShowedLeading == true {
                self.hideLeading(animated: animated, completion: { [weak self] in
                    guard let self = self else { return }
                    self.leading = leading
                    self.showLeading(animated: animated, completion: completion)
                })
            } else {
                self.leading = leading
            }
        } else {
            self.leading = leading
        }
    }
    
    func set(trailing: IHamburgerMenuContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated == true {
            if self.isShowedTrailing == true {
                self.hideTrailing(animated: animated, completion: { [weak self] in
                    guard let self = self else { return }
                    self.trailing = trailing
                    self.showTrailing(animated: animated, completion: completion)
                })
            } else {
                self.trailing = trailing
            }
        } else {
            self.trailing = trailing
        }
    }
    
}
