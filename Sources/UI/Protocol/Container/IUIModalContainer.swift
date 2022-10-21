//
//  KindKit
//

import Foundation

public protocol IUIModalContainer : IUIContainer, IUIContainerParentable {
    
    var content: (IUIContainer & IUIContainerParentable)? { set get }
    var containers: [IUIModalContentContainer] { get }
    var previous: IUIModalContentContainer? { get }
    var current: IUIModalContentContainer? { get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func present(container: IUIModalContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func present< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIModalContentContainer
    
    func dismiss(container: IUIModalContentContainer, animated: Bool, completion: (() -> Void)?)
    
    func dismiss< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIModalContentContainer
    
}
