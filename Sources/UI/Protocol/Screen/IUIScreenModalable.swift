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
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.modalContentContainer?.dismiss(animated: animated, completion: completion)
    }
    
}
