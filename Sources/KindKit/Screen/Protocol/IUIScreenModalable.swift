//
//  KindKit
//

import Foundation

@available(*, deprecated, renamed: "IScreenModalable")
public typealias IUIScreenModalable = IScreenModalable

public protocol IScreenModalable : AnyObject {
    
    var modalColor: UI.Color { get }
    var modalCornerRadius: UI.CornerRadius { get }
    var modalPresentation: UI.Screen.Modal.Presentation { get }
    
    func modalPressedOutside()
    
}

public extension IScreenModalable {
    
    var modalColor: UI.Color {
        return .white
    }
    
    var modalCornerRadius: UI.CornerRadius {
        return .none
    }
    
    var modalPresentation: UI.Screen.Modal.Presentation {
        return .simple
    }
    
}

public extension IScreenModalable where Self : IScreen {
    
    @inlinable
    var modalContentContainer: IUIModalContentContainer? {
        guard let contentContainer = self.container as? IUIModalContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var modalContainer: IUIModalContainer? {
        return self.modalContentContainer?.modalContainer
    }
    
    func modalPressedOutside() {
        self.close()
    }
    
}
