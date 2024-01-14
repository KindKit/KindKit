//
//  KindKit
//

import KindUI

public protocol IDialogContentContainer : IContainer, IContainerParentable {
    
    var dialogContainer: IDialogContainer? { get }
    
    var dialogInset: Inset { get }
    var dialogSize: Dialog.Size { get }
    var dialogAlignment: Dialog.Alignment { get }
    var dialogBackground: (IView & IViewAlphable)? { get }
    
    func dialogPressedOutside()
    
}

public extension IDialogContentContainer {
    
    @inlinable
    var dialogContainer: IDialogContainer? {
        return self.parent as? IDialogContainer
    }
    
    @inlinable
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.dialogContainer else { return false }
        container.dismiss(container: self, animated: animated, completion: completion)
        return true
    }
    
}
