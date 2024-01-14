//
//  KindKit
//

public protocol IViewDragDestinationtable : AnyObject {
    
    var dragDestination: DragAndDrop.Destination? { set get }
    
}

public extension IViewDragDestinationtable where Self : IWidgetView, Body : IViewDragDestinationtable {
    
    @inlinable
    var dragDestination: DragAndDrop.Destination? {
        set { self.body.dragDestination = newValue }
        get { self.body.dragDestination }
    }
    
}

public extension IViewDragDestinationtable {
    
    @inlinable
    @discardableResult
    func dragDestination(_ value: DragAndDrop.Destination?) -> Self {
        self.dragDestination = value
        return self
    }
    
    @inlinable
    @discardableResult
    func dragDestination(_ value: () -> DragAndDrop.Destination?) -> Self {
        return self.dragDestination(value())
    }

    @inlinable
    @discardableResult
    func dragDestination(_ value: (Self) -> DragAndDrop.Destination?) -> Self {
        return self.dragDestination(value(self))
    }
    
}
