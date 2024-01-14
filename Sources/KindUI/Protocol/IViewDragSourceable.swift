//
//  KindKit
//

public protocol IViewDragSourceable : AnyObject {
    
    var dragSource: DragAndDrop.Source? { set get }
    
}

public extension IViewDragSourceable where Self : IWidgetView, Body : IViewDragSourceable {
    
    @inlinable
    var dragSource: DragAndDrop.Source? {
        set { self.body.dragSource = newValue }
        get { self.body.dragSource }
    }
    
}

public extension IViewDragSourceable {
    
    @inlinable
    @discardableResult
    func dragSource(_ value: DragAndDrop.Source?) -> Self {
        self.dragSource = value
        return self
    }
    
    @inlinable
    @discardableResult
    func dragSource(_ value: () -> DragAndDrop.Source?) -> Self {
        return self.dragSource(value())
    }

    @inlinable
    @discardableResult
    func dragSource(_ value: (Self) -> DragAndDrop.Source?) -> Self {
        return self.dragSource(value(self))
    }
    
}
