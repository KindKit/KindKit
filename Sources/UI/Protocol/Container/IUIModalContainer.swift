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
    func dismiss(container: IUIModalContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIModalContainer {
    
    func present(container: IUIModalContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(container: container, animated: animated, completion: completion)
    }
    
    func dismiss(container: IUIModalContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(container: container, animated: animated, completion: completion)
    }
    
}
