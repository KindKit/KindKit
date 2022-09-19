//
//  KindKit
//

import Foundation

public protocol IUIModalContentContainer : IUIContainer, IUIContainerParentable {
        
    var modalContainer: IUIModalContainer? { get }
    
    var modalSheetInset: InsetFloat? { get }
    var modalSheetBackgroundView: (IUIView & IUIViewAlphable)? { get }
    
}

public extension IUIModalContentContainer {
    
    @inlinable
    var modalContainer: IUIModalContainer? {
        return self.parent as? IUIModalContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let modalContainer = self.modalContainer else {
            completion?()
            return
        }
        modalContainer.dismiss(container: self, animated: animated, completion: completion)
    }
    
}
