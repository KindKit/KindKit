//
//  KindKit
//

import Foundation

public protocol IUIViewDragSourceable : AnyObject {
    
    var dragSource: UI.DragAndDrop.Source? { set get }
    
}

public extension IUIViewDragSourceable where Self : IUIWidgetView, Body : IUIViewDragSourceable {
    
    @inlinable
    var dragSource: UI.DragAndDrop.Source? {
        set { self.body.dragSource = newValue }
        get { self.body.dragSource }
    }
    
}

public extension IUIViewDragSourceable {
    
    @inlinable
    @discardableResult
    func dragSource(_ value: UI.DragAndDrop.Source?) -> Self {
        self.dragSource = value
        return self
    }
    
    @inlinable
    @discardableResult
    func dragSource(_ value: () -> UI.DragAndDrop.Source?) -> Self {
        return self.dragSource(value())
    }

    @inlinable
    @discardableResult
    func dragSource(_ value: (Self) -> UI.DragAndDrop.Source?) -> Self {
        return self.dragSource(value(self))
    }
    
}
