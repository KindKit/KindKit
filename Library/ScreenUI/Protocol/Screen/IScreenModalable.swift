//
//  KindKit
//

import KindGraphics

public protocol IScreenModalable : AnyObject {
    
    var modalColor: Color { get }
    var modalCornerRadius: CornerRadius { get }
    var modalPresentation: Modal.Presentation { get }
    
    func modalPressedOutside()
    
}

public extension IScreenModalable {
    
    var modalColor: Color {
        return .white
    }
    
    var modalCornerRadius: CornerRadius {
        return .none
    }
    
    var modalPresentation: Modal.Presentation {
        return .simple
    }
    
}

public extension IScreenModalable where Self : IScreen {
    
    @inlinable
    var modalContentContainer: IModalContentContainer? {
        guard let contentContainer = self.container as? IModalContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var modalContainer: IModalContainer? {
        return self.modalContentContainer?.modalContainer
    }
    
    func modalPressedOutside() {
        self.close()
    }
    
}
