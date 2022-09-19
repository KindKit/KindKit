//
//  KindKit
//

import Foundation

public protocol IUIPageContainer : IUIContainer, IUIContainerParentable {
    
    var barView: UI.View.PageBar { get }
    var barVisibility: Float { get }
    var barHidden: Bool { get }
    var containers: [IUIPageContentContainer] { get }
    var backwardContainer: IUIPageContentContainer? { get }
    var currentContainer: IUIPageContentContainer? { get }
    var forwardContainer: IUIPageContentContainer? { get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func updateBar(animated: Bool, completion: (() -> Void)?)
    
    func update(container: IUIPageContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(containers: [IUIPageContentContainer], current: IUIPageContentContainer?, animated: Bool, completion: (() -> Void)?)
    func set(current: IUIPageContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIPageContainer {
    
    @inlinable
    func updateBar(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.updateBar(animated: animated, completion: completion)
    }
    
    @inlinable
    func update(container: IUIPageContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.update(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(containers: [IUIPageContentContainer], current: IUIPageContentContainer? = nil, animated: Bool = false, completion: (() -> Void)? = nil) {
        self.set(containers: containers, current: current, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(current: IUIPageContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(current: current, animated: animated, completion: completion)
    }
    
}
