//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenViewable : AnyObject {
    
    associatedtype AssociatedView : IView
    
    var view: AssociatedView { get }
    
    func didChangeInsets()
    
}

public extension IScreenViewable {
    
    func didChangeInsets() {
    }
    
}

public extension IScreenViewable where Self : IScreen, AssociatedView : IScrollView {
    
    func didChangeInsets() {
        self.view.contentInset = self.inheritedInsets()
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
