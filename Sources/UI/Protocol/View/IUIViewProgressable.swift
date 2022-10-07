//
//  KindKit
//

import Foundation

public protocol IUIViewProgressable : AnyObject {
    
    var progress: Float { set get }
    
}

public extension IUIViewProgressable where Self : IUIWidgetView, Body : IUIViewProgressable {
    
    @inlinable
    var progress: Float {
        set { self.body.progress = newValue }
        get { self.body.progress }
    }
    
}

public extension IUIViewProgressable {
    
    @inlinable
    @discardableResult
    func progress(_ value: Float) -> Self {
        self.progress = value
        return self
    }
    
}
