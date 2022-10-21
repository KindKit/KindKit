//
//  KindKit
//

import Foundation

public protocol IUIScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IUIView
    
    var view: AssociatedView { get }
    var overlayEdge: UI.Edge { get }
    
    func didChangeInsets()
    
}

public extension IUIScreenViewable {
    
    var overlayEdge: UI.Edge {
        return [ .top, .left, .right, .bottom ]
    }
    
}

public extension IUIScreenViewable where Self : IUIScreen, AssociatedView == UI.View.Scroll {
    
    func didChangeInsets() {
        let inheritedInsets = self.inheritedInsets()
        let overlayEdge = self.overlayEdge
        self.view.contentInset = .init(
            top: overlayEdge.contains(.top) ? inheritedInsets.top : 0,
            left: overlayEdge.contains(.left) ? inheritedInsets.left : 0,
            right: overlayEdge.contains(.right) ? inheritedInsets.right : 0,
            bottom: overlayEdge.contains(.bottom) ? inheritedInsets.bottom : 0
        )
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
