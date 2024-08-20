//
//  KindKit
//

import Foundation

public protocol IUIViewDragDestinationtable : AnyObject {
    
    var dragDestination: UI.DragAndDrop.Destination? { set get }
    
}

public extension IUIViewDragDestinationtable where Self : IUIWidgetView, Body : IUIViewDragDestinationtable {
    
    @inlinable
    var dragDestination: UI.DragAndDrop.Destination? {
        set { self.body.dragDestination = newValue }
        get { self.body.dragDestination }
    }
    
}

public extension IUIViewDragDestinationtable {
    
    @inlinable
    @discardableResult
    func dragDestination(_ value: UI.DragAndDrop.Destination?) -> Self {
        self.dragDestination = value
        return self
    }
    
    @inlinable
    @discardableResult
    func dragDestination(_ value: () -> UI.DragAndDrop.Destination?) -> Self {
        return self.dragDestination(value())
    }

    @inlinable
    @discardableResult
    func dragDestination(_ value: (Self) -> UI.DragAndDrop.Destination?) -> Self {
        return self.dragDestination(value(self))
    }
    
}
