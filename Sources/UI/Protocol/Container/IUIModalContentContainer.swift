//
//  KindKit
//

import Foundation

public protocol IUIModalContentContainer : IUIContainer, IUIContainerParentable {
        
    var modalContainer: IUIModalContainer? { get }
    
    var modalSheetInset: InsetFloat? { get }
    var modalSheetBackground: (IUIView & IUIViewAlphable)? { get }
    
}

public extension IUIModalContentContainer {
    
    @inlinable
    var modalContainer: IUIModalContainer? {
        return self.parent as? IUIModalContainer
    }
    
    @inlinable
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.modalContainer else { return false }
        container.dismiss(container: self, animated: animated, completion: completion)
        return true
    }
    
}
