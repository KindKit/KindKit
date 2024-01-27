//
//  KindKit
//

public protocol IViewSupportDragSource : AnyObject {
    
    var dragSource: DragAndDrop.Source? { set get }
    
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
    func dragSource(on: () -> DragAndDrop.Source?) -> Self {
        self.dragSource = on()
        return self
    }

    @inlinable
    @discardableResult
    func dragSource(on: (Self) -> DragAndDrop.Source?) -> Self {
        self.dragSource = on(self)
        return self
    }
    
}

public extension IViewSupportDragSource where Self : CompositorTrait, Body : IViewSupportDragSource {
    
    @inlinable
    var dragSource: DragAndDrop.Source? {
        set { self.body.dragSource = newValue }
        get { self.body.dragSource }
    }
    
}
