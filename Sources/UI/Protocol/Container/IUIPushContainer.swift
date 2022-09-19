//
//  KindKit
//

import Foundation

public protocol IUIPushContainer : IUIContainer, IUIContainerParentable {
    
    var additionalInset: InsetFloat { set get }
    var contentContainer: (IUIContainer & IUIContainerParentable)? { set get }
    var containers: [IUIPushContentContainer] { get }
    var previousContainer: IUIPushContentContainer? { get }
    var currentContainer: IUIPushContentContainer? { get }
    var animationVelocity: Float { set get }
#if os(iOS)
    var interactiveLimit: Float { set get }
#endif
    
    func present(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IUIPushContainer {
    
    @inlinable
    func present(container: IUIPushContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func dismiss(container: IUIPushContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(container: container, animated: animated, completion: completion)
    }
    
}
