//
//  KindKit
//

public protocol IViewSupportDragDestination : AnyObject {
    
    var dragDestination: DragAndDrop.Destination? { set get }
    
}

public extension IViewSupportDragDestination where Self : IComposite, BodyType : IViewSupportDragDestination {
    
    @inlinable
    var dragDestination: DragAndDrop.Destination? {
        set { self.body.dragDestination = newValue }
        get { self.body.dragDestination }
    }
    
}

public extension IViewSupportDragDestination {
    
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
