//
//  KindKit
//

public protocol IViewSupportDragDestination : AnyObject {
    
    var dragDestination: DragAndDrop.Destination? { set get }
    
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
    func dragDestination(on: () -> DragAndDrop.Destination?) -> Self {
        self.dragDestination = on()
        return self
    }

    @inlinable
    @discardableResult
    func dragDestination(on: (Self) -> DragAndDrop.Destination?) -> Self {
        self.dragDestination = on(self)
        return self
    }
    
}

public extension IViewSupportDragDestination where Self : CompositorTrait, Body : IViewSupportDragDestination {
    
    @inlinable
    var dragDestination: DragAndDrop.Destination? {
        set { self.body.dragDestination = newValue }
        get { self.body.dragDestination }
    }
    
}
