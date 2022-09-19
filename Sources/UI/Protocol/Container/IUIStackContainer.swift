//
//  KindKit
//

import Foundation

public protocol IUIStackContainer : IUIContainer, IUIContainerParentable {
    
    var rootContainer: IUIStackContentContainer { get }
    var containers: [IUIStackContentContainer] { get }
    var currentContainer: IUIStackContentContainer { get }
    var hidesGroupBarWhenPushed: Bool { set get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func update(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(rootContainer: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func set(containers: [IUIStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func push(containers: [IUIStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIStackContentContainer
    func pop(animated: Bool, completion: (() -> Void)?)
    func popTo(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIStackContainer {
    
    @inlinable
    func update(container: IUIStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.update(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(rootContainer: IUIStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(rootContainer: rootContainer, animated: animated, completion: completion)
    }
    
    @inlinable
    func set(containers: [IUIStackContentContainer], animated: Bool = true, completion: (() -> Void)? = nil) {
        self.set(containers: containers, animated: animated, completion: completion)
    }
    
    @inlinable
    func push(container: IUIStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.push(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func push(containers: [IUIStackContentContainer], animated: Bool = true, completion: (() -> Void)? = nil) {
        self.push(containers: containers, animated: animated, completion: completion)
    }
    
    @inlinable
    func push< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool = true, completion: (() -> Void)? = nil) where Wireframe : AnyObject, Wireframe.Container : IUIStackContentContainer {
        self.push(wireframe: wireframe, animated: animated, completion: completion)
    }
    
    @inlinable
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.pop(animated: animated, completion: completion)
    }
    
    @inlinable
    func popTo(container: IUIStackContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.popTo(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.popToRoot(animated: animated, completion: completion)
    }
    
}
