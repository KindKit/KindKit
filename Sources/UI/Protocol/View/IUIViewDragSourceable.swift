//
//  KindKit
//

import Foundation

public protocol IUIViewDragSourceable : AnyObject {
    
    var dragSource: IUIDragAndDropSource? { set get }
    
}

public extension IUIViewDragSourceable where Self : IUIWidgetView, Body : IUIViewDragSourceable {
    
    @inlinable
    var dragSource: IUIDragAndDropSource? {
        set { self.body.dragSource = newValue }
        get { self.body.dragSource }
    }
    
}

public extension IUIViewDragSourceable {
    
    @inlinable
    @discardableResult
    func dragSource(_ value: IUIDragAndDropSource?) -> Self {
        self.dragSource = value
        return self
    }
    
}
