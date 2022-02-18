//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IPageContainer : IContainer, IContainerParentable {
    
    var barView: IPageBarView { get }
    var barVisibility: Float { get }
    var barHidden: Bool { get }
    var containers: [IPageContentContainer] { get }
    var backwardContainer: IPageContentContainer? { get }
    var currentContainer: IPageContentContainer? { get }
    var forwardContainer: IPageContentContainer? { get }
    var animationVelocity: Float { set get }
    #if os(iOS)
    var interactiveLimit: Float { set get }
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

public protocol IPageContentContainer : IContainer, IContainerParentable {
    
    var pageContainer: IPageContainer? { get }
    
    var pageItemView: IBarItemView { get }
    
}

public extension IPageContentContainer {
    
    @inlinable
    var pageContainer: IPageContainer? {
        return self.parent as? IPageContainer
    }
    
    @inlinable
    func updatePageBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let pageContainer = self.pageContainer else {
            completion?()
            return
        }
        pageContainer.updateBar(animated: animated, completion: completion)
    }
    
}
