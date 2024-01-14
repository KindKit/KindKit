//
//  KindKit
//

import KindUI

public protocol IPageContainer : IContainer, IContainerParentable {
    
    var bar: PageBarView { get }
    var barVisibility: Double { get }
    var barHidden: Bool { get }
    var containers: [IPageContentContainer] { get }
    var backward: IPageContentContainer? { get }
    var current: IPageContentContainer? { get }
    var forward: IPageContentContainer? { get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func updateBar(animated: Bool, completion: (() -> Void)?)
    
    func update(container: IPageContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(containers: [IPageContentContainer], current: IPageContentContainer?, animated: Bool, completion: (() -> Void)?)
    func set(current: IPageContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IPageContainer {
    
    @inlinable
    func updateBar(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.updateBar(animated: animated, completion: completion)
    }
    
    @inlinable
    func update(container: IPageContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.update(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(containers: [IPageContentContainer], current: IPageContentContainer? = nil, animated: Bool = false, completion: (() -> Void)? = nil) {
        self.set(containers: containers, current: current, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(current: IPageContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(current: current, animated: animated, completion: completion)
    }
    
}
