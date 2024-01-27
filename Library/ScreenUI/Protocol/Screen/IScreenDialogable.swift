//
//  KindKit
//

import KindUI

public protocol IScreenDialogable : AnyObject {
    
    var dialogInset: Inset { get }
    var dialogSize: Dialog.Size { get }
    var dialogAlignment: Dialog.Alignment { get }
    var dialogBackgroundView: (IView & IViewAlphable)? { get }
    
    func dialogPressedOutside()
    
}

public extension IScreenDialogable {
    
    var dialogInset: Inset {
        return .zero
    }
    
    var dialogSize: Dialog.Size {
        return .init(.fit, .fit)
    }
    
    var dialogAlignment: Dialog.Alignment {
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
    
    func dialogPressedOutside() {
        self.close()
    }
    
}
