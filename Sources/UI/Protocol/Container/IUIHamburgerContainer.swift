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
    
    func set(leading: IHamburgerMenuContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard self.leading !== leading else {
        	completion?()
        	return
        }
        if animated == true {
            if self.isShowedLeading == true {
                self.hideLeading(animated: animated, completion: { [weak self] in
                    guard let self = self else { return }
                    self.leading = leading
                    self.showLeading(animated: animated, completion: completion)
                })
            } else {
                self.leading = leading
        		completion?()
            }
        } else {
            self.leading = leading
        	completion?()
        }
    }
    
    func set(trailing: IHamburgerMenuContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard self.trailing !== trailing else {
        	completion?()
        	return
        }
        if animated == true {
            if self.isShowedTrailing == true {
                self.hideTrailing(animated: animated, completion: { [weak self] in
                    guard let self = self else { return }
                    self.trailing = trailing
                    self.showTrailing(animated: animated, completion: completion)
                })
            } else {
                self.trailing = trailing
        		completion?()
            }
        } else {
            self.trailing = trailing
        	completion?()
        }
    }
    
}
