//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenDialogable")
public typealias IUIScreenDialogable = IScreenDialogable

public protocol IScreenDialogable : AnyObject {
    
    var dialogInset: Inset { get }
    var dialogSize: UI.Dialog.Size { get }
    var dialogAlignment: UI.Dialog.Alignment { get }
    var dialogBackgroundView: (IUIView & IUIViewAlphable)? { get }
    
    func dialogPressedOutside()
    
}

public extension IScreenDialogable {
    
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

public extension IScreenDialogable where Self : IScreen {
    
    @inlinable
    var dialogContentContainer: IUIDialogContentContainer? {
        guard let contentContainer = self.container as? IUIDialogContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var dialogContainer: IUIDialogContainer? {
        return self.dialogContentContainer?.dialogContainer
    }
    
    func dialogPressedOutside() {
        self.close()
    }
    
}
