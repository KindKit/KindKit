//
//  KindKit
//

public protocol IModalContainer : IContainer, IContainerParentable {
    
    var content: (IContainer & IContainerParentable)? { set get }
    var containers: [IModalContentContainer] { get }
    var previous: IModalContentContainer? { get }
    var current: IModalContentContainer? { get }
    var animationVelocity: Double { set get }
    
    func present(container: IModalContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func present< Wireframe : IWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IModalContentContainer
    
    @discardableResult
    func dismiss(container: IModalContentContainer, animated: Bool, completion: (() -> Void)?) -> Bool
    
    @discardableResult
    func dismiss< Wireframe : IWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) -> Bool where Wireframe : AnyObject, Wireframe.Container : IModalContentContainer
    
}
