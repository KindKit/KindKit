//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IDialogContainer : IContainer, IContainerParentable {
    
    var contentContainer: (IContainer & IContainerParentable)? { set get }
    var containers: [IDialogContentContainer] { get }
    var previousContainer: IDialogContentContainer? { get }
    var currentContainer: IDialogContentContainer? { get }
    var animationVelocity: Float { set get }
    #if os(iOS)
    var interactiveLimit: Float { set get }
    #endif
    
    func present(container: IDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    func dismiss(container: IDialogContentContainer, animated: Bool, completion: (() -> Void)?)
    
}

public extension IDialogContainer {
    
    @inlinable
    func present(container: IDialogContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(container: container, animated: animated, completion: completion)
    }
    
    @inlinable
    func dismiss(container: IDialogContentContainer, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(container: container, animated: animated, completion: completion)
    }
    
}

public enum DialogContentContainerSize : Equatable {
    case fill(before: Float, after: Float)
    case fixed(value: Float)
    case fit
}

public enum DialogContentContainerAlignment {
    case topLeft
    case top
    case topRight
    case centerLeft
    case center
    case centerRight
    case bottomLeft
    case bottom
    case bottomRight
}

public protocol IDialogContentContainer : IContainer, IContainerParentable {
    
    var dialogContainer: IDialogContainer? { get }
    
    var dialogInset: InsetFloat { get }
    var dialogWidth: DialogContentContainerSize { get }
    var dialogHeight: DialogContentContainerSize { get }
    var dialogAlignment: DialogContentContainerAlignment { get }
    var dialogBackgroundView: (IView & IViewAlphable)? { get }
    
}

public extension IDialogContentContainer {
    
    @inlinable
    var dialogContainer: IDialogContainer? {
        return self.parent as? IDialogContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let dialogContainer = self.dialogContainer else {
            completion?()
            return
        }
        dialogContainer.dismiss(container: self, animated: animated, completion: completion)
    }
    
}
