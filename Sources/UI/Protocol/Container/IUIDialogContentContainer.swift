//
//  KindKit
//

import Foundation

public enum DialogContentContainerSize : Equatable {
    
    case fill(before: Double, after: Double)
    case fixed(value: Double)
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
    
    var dialogInset: Inset { get }
    var dialogWidth: DialogContentContainerSize { get }
    var dialogHeight: DialogContentContainerSize { get }
    var dialogAlignment: DialogContentContainerAlignment { get }
    var dialogBackground: (IUIView & IUIViewAlphable)? { get }
    
}

public extension IUIDialogContentContainer {
    
    @inlinable
    var dialogContainer: IUIDialogContainer? {
        return self.parent as? IUIDialogContainer
    }
    
    @inlinable
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.dialogContainer else { return false }
        container.dismiss(container: self, animated: animated, completion: completion)
        return true
    }
    
}
