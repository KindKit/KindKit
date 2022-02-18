//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenViewable : AnyObject {
    
    associatedtype View : IView
    
    var view: View { get }
    
    func didChangeInsets()
    
}

public extension IScreenViewable {
    
    func didChangeInsets() {
    }
    
}

public extension IScreenViewable where Self : IScreen, View : IScrollView {
    
    func didChangeInsets() {
        self.view.contentInset = self.inheritedInsets()
    }
    
    func activate() -> Bool {
        self.view.scrollToTop()
        return true
    }
    
}
