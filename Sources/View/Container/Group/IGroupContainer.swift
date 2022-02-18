//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGroupContainer : IContainer, IContainerParentable {
    
    var barView: IGroupBarView { get }
    var barVisibility: Float { get }
    var barHidden: Bool { get }
    var containers: [IGroupContentContainer] { get }
    var backwardContainer: IGroupContentContainer? { get }
    var currentContainer: IGroupContentContainer? { get }
    var forwardContainer: IGroupContentContainer? { get }
    var animationVelocity: Float { set get }
    
    func updateBar(animated: Bool, completion: (() -> Void)?)
    
    func update(container: IGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(containers: [IGroupContentContainer], current: IGroupContentContainer?, animated: Bool, completion: (() -> Void)?)
    func set(current: IGroupContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IGroupContainer {
    
    @inlinable
    func update(container: IGroupContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.update(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(containers: [IGroupContentContainer], current: IGroupContentContainer? = nil, animated: Bool = false, completion: (() -> Void)? = nil) {
        self.set(containers: containers, current: current, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(current: IGroupContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(current: current, animated: animated, completion: completion)
    }
    
}

public protocol IGroupContentContainer : IContainer, IContainerParentable {
    
    var groupContainer: IGroupContainer? { get }
    
    var groupItemView: IBarItemView { get }
    
}

public extension IGroupContentContainer {
    
    var groupContainer: IGroupContainer? {
        return self.parent as? IGroupContainer
    }
    
    func updateGroupBar(animated: Bool, completion: (() -> Void)? = nil) {
        guard let groupContainer = self.groupContainer else {
            completion?()
            return
        }
        groupContainer.updateBar(animated: animated, completion: completion)
    }
    
}
