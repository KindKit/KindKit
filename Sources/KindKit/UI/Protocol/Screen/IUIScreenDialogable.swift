//
//  KindKit
//

import Foundation

public protocol IUIScreenDialogable : AnyObject {
    
    var dialogInset: Inset { get }
    var dialogSize: UI.Dialog.Size { get }
    var dialogAlignment: UI.Dialog.Alignment { get }
    var dialogBackgroundView: (IUIView & IUIViewAlphable)? { get }
    
    func dialogPressedOutside()
    
}

public extension IUIScreenDialogable {
    
    var dialogInset: Inset {
        return .zero
    }
    
    var dialogSize: UI.Dialog.Size {
        return .init(.fit, .fit)
    }
    
    var dialogAlignment: UI.Dialog.Alignment {
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
    func dialogDismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.dialogContentContainer else { return false }
        return container.dismiss(animated: animated, completion: completion)
    }
    
    func dialogPressedOutside() {
        self.dialogDismiss()
    }
    
}
