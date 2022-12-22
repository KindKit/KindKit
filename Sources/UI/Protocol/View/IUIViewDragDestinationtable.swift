//
//  KindKit
//

import Foundation

public protocol IUIViewDragDestinationtable : AnyObject {
    
    var dragDestination: IUIDragAndDropDestination? { set get }
    
}

public extension IUIViewDragDestinationtable where Self : IUIWidgetView, Body : IUIViewDragDestinationtable {
    
    @inlinable
    var dragDestination: IUIDragAndDropDestination? {
        set { self.body.dragDestination = newValue }
        get { self.body.dragDestination }
    }
    
}

public extension IUIViewDragDestinationtable {
    
    @inlinable
    @discardableResult
    func dragDestination(_ value: IUIDragAndDropDestination?) -> Self {
        self.dragDestination = value
        return self
    }
    
}
