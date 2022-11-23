//
//  KindKit
//

import Foundation

public protocol IUIScreenDialogable : AnyObject {
    
    var dialogInset: Inset { get }
    var dialogWidth: DialogContentContainerSize { get }
    var dialogHeight: DialogContentContainerSize { get }
    var dialogAlignment: DialogContentContainerAlignment { get }
    var dialogBackgroundView: (IUIView & IUIViewAlphable)? { get }
    
}

public extension IUIScreenDialogable {
    
    var dialogInset: Inset {
        return .zero
    }
    
    var dialogWidth: DialogContentContainerSize {
        return .fit
    }
    
    var dialogHeight: DialogContentContainerSize {
        return .fit
    }
    
    var dialogAlignment: DialogContentContainerAlignment {
        return .center
    }
    
    var dialogBackgroundView: (IUIView & IUIViewAlphable)? {
        return nil
    }
    
}

public extension IUIScreenDialogable where Self : IUIScreen {
    
    @inlinable
    var dialogContentContainer: IUIDialogContentContainer? {
        guard let contentContainer = self.container as? IUIDialogContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var dialogContainer: IUIDialogContainer? {
        return self.dialogContentContainer?.dialogContainer
    }
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.dialogContentContainer else { return false }
        return container.dismiss(animated: animated, completion: completion)
    }
    
}
