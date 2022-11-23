//
//  KindKit
//

import Foundation

public protocol IUIScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IUIView
    
    var view: AssociatedView { get }
    var overlayEdge: UI.Edge { get }
    
    func apply(inset: UI.Container.AccumulateInset)
    
}

public extension IUIScreenViewable {
    
    var overlayEdge: UI.Edge {
        return [ .top, .left, .right, .bottom ]
    }
    
}

public extension IUIScreenViewable where Self : IUIScreen, AssociatedView == UI.View.Scroll {
    
    func apply(inset: UI.Container.AccumulateInset, in view: UI.View.Scroll) {
        let overlayEdge = self.overlayEdge
        view.contentInset = .init(
            top: overlayEdge.contains(.top) ? inset.natural.top : 0,
            left: overlayEdge.contains(.left) ? inset.natural.left : 0,
            right: overlayEdge.contains(.right) ? inset.natural.right : 0,
            bottom: overlayEdge.contains(.bottom) ? inset.natural.bottom : 0
        )
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
