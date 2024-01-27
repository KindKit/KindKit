//
//  KindKit
//

public protocol IViewSupportDragSource : AnyObject {
    
    var dragSource: DragAndDrop.Source? { set get }
    
}

public extension IViewSupportDragSource where Self : IComposite, BodyType : IViewSupportDragSource {
    
    @inlinable
    var dragSource: DragAndDrop.Source? {
        set { self.body.dragSource = newValue }
        get { self.body.dragSource }
    }
    
}

public extension IViewSupportDragSource {
    
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
