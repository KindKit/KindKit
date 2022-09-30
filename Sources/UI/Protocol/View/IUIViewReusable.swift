//
//  KindKit
//

import Foundation

public protocol IUIViewReusable : AnyObject {
    
    var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour { set get }
    var reuseCache: UI.Reuse.Cache? { set get }
    var reuseName: String? { set get }
    
}

public extension IUIViewReusable {
    
    @inlinable
    @discardableResult
    func reuseUnloadBehaviour(_ value: UI.Reuse.UnloadBehaviour) -> Self {
        self.reuseUnloadBehaviour = value
        return self
    }
    
    @inlinable
    @discardableResult
    func reuseCache(_ value: UI.Reuse.Cache?) -> Self {
        self.reuseCache = value
        return self
    }
    
    @inlinable
    @discardableResult
    func reuseName(_ value: String?) -> Self {
        self.reuseName = value
        return self
    }
    
}

public extension IUIViewReusable where Self : IUIWidgetView, Body : IUIViewReusable {
    
    @inlinable
    var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self.body.reuseUnloadBehaviour = newValue }
        get { return self.body.reuseUnloadBehaviour }
    }
    var reuseCache: UI.Reuse.Cache? {
        set { self.body.reuseCache = newValue }
        get { return self.body.reuseCache }
    }
    var reuseName: String? {
        set { self.body.reuseName = newValue }
        get { return self.body.reuseName }
    }
    
}
