//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenDialogable : AnyObject {
    
    var dialogInset: InsetFloat { get }
    var dialogWidth: DialogContentContainerSize { get }
    var dialogHeight: DialogContentContainerSize { get }
    var dialogAlignment: DialogContentContainerAlignment { get }
    var dialogBackgroundView: (IView & IViewAlphable)? { get }
    
}

public extension IScreenDialogable {
    
    var dialogInset: InsetFloat {
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
    
    var dialogBackgroundView: (IView & IViewAlphable)? {
        return nil
    }
    
}

public extension IScreenDialogable where Self : IScreen {
    
    @inlinable
    var dialogContentContainer: IDialogContentContainer? {
        guard let contentContainer = self.container as? IDialogContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var dialogContainer: IDialogContainer? {
        return self.dialogContentContainer?.dialogContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dialogContentContainer?.dismiss(animated: animated, completion: completion)
    }
    
}
