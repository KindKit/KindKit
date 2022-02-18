//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IModalContainer : IContainer, IContainerParentable {
    
    var contentContainer: (IContainer & IContainerParentable)? { set get }
    var containers: [IModalContentContainer] { get }
    var previousContainer: IModalContentContainer? { get }
    var currentContainer: IModalContentContainer? { get }
    var animationVelocity: Float { set get }
    #if os(iOS)
    var interactiveLimit: Float { set get }
    #endif
    
    func present(container: IModalContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IModalContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IModalContainer {
    
    func present(container: IModalContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(container: container, animated: animated, completion: completion)
    }
    
    func dismiss(container: IModalContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(container: container, animated: animated, completion: completion)
    }
    
}

public protocol IModalContentContainer : IContainer, IContainerParentable {
        
    var modalContainer: IModalContainer? { get }
    
    var modalSheetInset: InsetFloat? { get }
    var modalSheetBackgroundView: (IView & IViewAlphable)? { get }
    
}

public extension IModalContentContainer {
    
    @inlinable
    var modalContainer: IModalContainer? {
        return self.parent as? IModalContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let modalContainer = self.modalContainer else {
            completion?()
            return
        }
        modalContainer.dismiss(container: self, animated: animated, completion: completion)
    }
    
}
