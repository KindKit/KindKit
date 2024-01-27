//
//  KindKit
//

import KindGraphics

public protocol IModalContentContainer : IContainer, IContainerParentable {
        
    var modalContainer: IModalContainer? { get }
    var modalColor: Color { get }
    var modalSheet: Modal.Presentation.Sheet? { get }
    
    func modalPressedOutside()
    
}

public extension IModalContentContainer {
    
    @inlinable
    var modalContainer: IModalContainer? {
        return self.parent as? IModalContainer
    }
    
    @inlinable
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        guard let container = self.modalContainer else { return false }
        container.dismiss(container: self, animated: animated, completion: completion)
        return true
    }
    
}
