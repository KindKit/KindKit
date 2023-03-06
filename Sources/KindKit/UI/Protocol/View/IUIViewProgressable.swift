//
//  KindKit
//

import Foundation

public protocol IUIViewProgressable : AnyObject {
    
    var progress: Double { set get }
    
}

public extension IUIViewProgressable where Self : IUIWidgetView, Body : IUIViewProgressable {
    
    @inlinable
    var progress: Double {
        set { self.body.progress = newValue }
        get { self.body.progress }
    }
    
}

public extension IUIViewProgressable {
    
    @inlinable
    @discardableResult
    func progress(_ value: Double) -> Self {
        self.progress = value
        return self
    }
    
}
