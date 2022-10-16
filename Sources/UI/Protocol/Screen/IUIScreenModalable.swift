//
//  KindKit
//

import Foundation

public protocol IUIScreenModalable : AnyObject {
    
    var modalPresentation: UI.Screen.Modal.Presentation { get }
    
}

public extension IUIScreenModalable {
    
    var modalPresentation: UI.Screen.Modal.Presentation {
        return .simple
    }
    
}

public extension IUIScreenModalable where Self : IUIScreen {
    
    @inlinable
    var modalContentContainer: IUIModalContentContainer? {
        guard let contentContainer = self.container as? IUIModalContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var modalContainer: IUIModalContainer? {
        return self.modalContentContainer?.modalContainer
    }
    
    @discardableResult
    func modalDismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.modalContentContainer else { return false }
        return container.dismiss(animated: animated, completion: completion)
    }
    
}
