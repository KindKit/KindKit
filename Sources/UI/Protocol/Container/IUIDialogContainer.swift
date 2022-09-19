//
//  KindKit
//

import Foundation

public protocol IUIDialogContainer : IUIContainer, IUIContainerParentable {
    
    var contentContainer: (IUIContainer & IUIContainerParentable)? { set get }
    var containers: [IUIDialogContentContainer] { get }
    var previousContainer: IUIDialogContentContainer? { get }
    var currentContainer: IUIDialogContentContainer? { get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func present(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIDialogContainer {
    
    @inlinable
    func present(container: IUIDialogContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func dismiss(container: IUIDialogContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(container: container, animated: animated, completion: completion)
    }
    
}
