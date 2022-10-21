//
//  KindKit
//

import Foundation

public protocol IUIStackContainer : IUIContainer, IUIContainerParentable {
    
    var root: IUIStackContentContainer { get }
    var containers: [IUIStackContentContainer] { get }
    var current: IUIStackContentContainer { get }
    var hidesGroupBarWhenPushed: Bool { set get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func update(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(root: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func set(containers: [IUIStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func push(containers: [IUIStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIStackContentContainer
    func pop(animated: Bool, completion: (() -> Void)?)
    func popTo(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    
}
