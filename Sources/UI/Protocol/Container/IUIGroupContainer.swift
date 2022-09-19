//
//  KindKit
//

import Foundation

public protocol IUIGroupContainer : IUIContainer, IUIContainerParentable {
    
    var barView: UI.View.GroupBar { get }
    var barVisibility: Float { get }
    var barHidden: Bool { get }
    var containers: [IUIGroupContentContainer] { get }
    var backwardContainer: IUIGroupContentContainer? { get }
    var currentContainer: IUIGroupContentContainer? { get }
    var forwardContainer: IUIGroupContentContainer? { get }
    var animationVelocity: Float { set get }
    
    func updateBar(animated: Bool, completion: (() -> Void)?)
    
    func update(container: IUIGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(containers: [IUIGroupContentContainer], current: IUIGroupContentContainer?, animated: Bool, completion: (() -> Void)?)
    func set(current: IUIGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIGroupContainer {
    
    @inlinable
    func update(container: IUIGroupContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.update(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(containers: [IUIGroupContentContainer], current: IUIGroupContentContainer? = nil, animated: Bool = false, completion: (() -> Void)? = nil) {
        self.set(containers: containers, current: current, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(current: IUIGroupContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(current: current, animated: animated, completion: completion)
    }
    
}
