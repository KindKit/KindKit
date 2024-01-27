//
//  KindKit
//

public protocol IStackContainer : IContainer, IContainerParentable {
    
    var root: IStackContentContainer { get }
    var containers: [IStackContentContainer] { get }
    var current: IStackContentContainer { get }
    var hidesGroupBarWhenPushed: Bool { set get }
    var animationVelocity: Double { set get }
#if os(iOS)
    var interactiveLimit: Double { set get }
#endif
    
    func update(container: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func set(root: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func set(containers: [IStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push(container: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func push(containers: [IStackContentContainer], animated: Bool, completion: (() -> Void)?)
    func push< Wireframe : IWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IStackContentContainer
    func pop(animated: Bool, completion: (() -> Void)?)
    func popTo(container: IStackContentContainer, animated: Bool, completion: (() -> Void)?)
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    
}
