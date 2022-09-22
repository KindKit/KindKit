//
//  KindKit
//

import Foundation

public protocol IUIViewProgressable : AnyObject {
    
    var progress: Float { set get }
    
}

public extension IUIViewProgressable {
    
    @inlinable
    @discardableResult
    func progress(_ value: Float) -> Self {
        self.progress = value
        return self
    }
    
}

public extension IUIViewProgressable where Self : IUIWidgetView, Body : IUIViewProgressable {
    
    @inlinable
    var progress: Float {
        set(value) { self.body.progress = value }
        get { return self.body.progress }
    }
    
}