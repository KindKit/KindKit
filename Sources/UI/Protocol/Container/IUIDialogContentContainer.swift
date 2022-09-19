//
//  KindKit
//

import Foundation

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

public protocol IUIDialogContentContainer : IUIContainer, IUIContainerParentable {
    
    var dialogContainer: IUIDialogContainer? { get }
    
    var dialogInset: InsetFloat { get }
    var dialogWidth: DialogContentContainerSize { get }
    var dialogHeight: DialogContentContainerSize { get }
    var dialogAlignment: DialogContentContainerAlignment { get }
    var dialogBackgroundView: (IUIView & IUIViewAlphable)? { get }
    
}

public extension IUIDialogContentContainer {
    
    @inlinable
    var dialogContainer: IUIDialogContainer? {
        return self.parent as? IUIDialogContainer
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
