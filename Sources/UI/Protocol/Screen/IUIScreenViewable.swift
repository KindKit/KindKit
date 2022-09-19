//
//  KindKit
//

import Foundation

public protocol IUIScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IUIView
    
    var view: AssociatedView { get }
    
    func didChangeInsets()
    
}

public extension IUIScreenViewable {
    
    func didChangeInsets() {
    }
    
}

public extension IUIScreenViewable where Self : IUIScreen, AssociatedView == UI.View.Scroll {
    
    func didChangeInsets() {
        self.view.contentInset = self.inheritedInsets()
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
