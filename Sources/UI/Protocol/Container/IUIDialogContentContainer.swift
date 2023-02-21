//
//  KindKit
//

import Foundation

public protocol IUIDialogContentContainer : IUIContainer, IUIContainerParentable {
    
    var dialogContainer: IUIDialogContainer? { get }
    
    var dialogInset: Inset { get }
    var dialogSize: UI.Dialog.Size { get }
    var dialogAlignment: UI.Dialog.Alignment { get }
    var dialogBackground: (IUIView & IUIViewAlphable)? { get }
    
    func dialogPressedOutside()
    
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
