//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IStackContainer : IContainer, IContainerParentable {
    
    var rootContainer: IStackContentContainer { get }
    var containers: [IStackContentContainer] { get }
    var currentContainer: IStackContentContainer { get }
    var hidesGroupBarWhenPushed: Bool { set get }
    var animationVelocity: Float { set get }
    #if os(iOS)
    var interactiveLimit: Float { set get }
    #endif
    
    func update(container: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(rootContainer: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func set(containers: [IStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push(container: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func push(containers: [IStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push< Wireframe: IWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IStackContentContainer
    func pop(animated: Bool, completion: (() -> Void)?)
    func popTo(container: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    
}

public extension IStackContainer {
    
    @inlinable
    func update(container: IStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.update(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(rootContainer: IStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(rootContainer: rootContainer, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(containers: [IStackContentContainer], animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(containers: containers, animated: animated, completion: completion)
    }
    
    @inlinable
    func push(container: IStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.push(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func push(containers: [IStackContentContainer], animated: Bool = true, completion: (() -> Void)? = nil) {
        self.push(containers: containers, animated: animated, completion: completion)
    }
    
    @inlinable
    func push< Wireframe: IWireframe >(wireframe: Wireframe, animated: Bool = true, completion: (() -> Void)? = nil) where Wireframe : AnyObject, Wireframe.Container : IStackContentContainer {
        self.push(wireframe: wireframe, animated: animated, completion: completion)
    }
    
    @inlinable
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.pop(animated: animated, completion: completion)
    }
    
    @inlinable
    func popTo(container: IStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.popTo(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.popToRoot(animated: animated, completion: completion)
    }
    
}

public protocol IStackContentContainer : IContainer, IContainerParentable {
    
    var stackContainer: IStackContainer? { get }
    
    var stackBarView: IStackBarView { get }
    var stackBarVisibility: Float { get }
    var stackBarHidden: Bool { get }
    
}

public extension IStackContentContainer {
    
    @inlinable
    var stackContainer: IStackContainer? {
        return self.parent as? IStackContainer
    }
    
    @inlinable
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let stackContainer = self.stackContainer else {
            completion?()
            return
        }
        stackContainer.pop(animated: animated, completion: completion)
    }
    
    @inlinable
    func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let stackContainer = self.stackContainer else {
            completion?()
            return
        }
        stackContainer.popToRoot(animated: animated, completion: completion)
    }
    
}
