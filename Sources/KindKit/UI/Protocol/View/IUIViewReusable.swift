//
//  KindKit
//

import Foundation

public protocol IUIViewReusable : AnyObject {
    
    var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour { set get }
    var reuseCache: UI.Reuse.Cache? { set get }
    var reuseName: String? { set get }
    
}

public extension IUIViewReusable where Self : IUIWidgetView, Body : IUIViewReusable {
    
    @inlinable
    var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self.body.reuseUnloadBehaviour = newValue }
        get { self.body.reuseUnloadBehaviour }
    }
    var reuseCache: UI.Reuse.Cache? {
        set { self.body.reuseCache = newValue }
        get { self.body.reuseCache }
    }
    var reuseName: String? {
        set { self.body.reuseName = newValue }
        get { self.body.reuseName }
    }
    
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
    func reuseUnloadBehaviour(_ value: () -> UI.Reuse.UnloadBehaviour) -> Self {
        return self.reuseUnloadBehaviour(value())
    }

    @inlinable
    @discardableResult
    func reuseUnloadBehaviour(_ value: (Self) -> UI.Reuse.UnloadBehaviour) -> Self {
        return self.reuseUnloadBehaviour(value(self))
    }
    
    @inlinable
    @discardableResult
    func reuseCache(_ value: UI.Reuse.Cache?) -> Self {
        self.reuseCache = value
        return self
    }
    
    @inlinable
    @discardableResult
    func reuseCache(_ value: () -> UI.Reuse.Cache?) -> Self {
        return self.reuseCache(value())
    }

    @inlinable
    @discardableResult
    func reuseCache(_ value: (Self) -> UI.Reuse.Cache?) -> Self {
        return self.reuseCache(value(self))
    }
    
    @inlinable
    @discardableResult
    func reuseName(_ value: String?) -> Self {
        self.reuseName = value
        return self
    }
    
    @inlinable
    @discardableResult
    func reuseName(_ value: () -> String?) -> Self {
        return self.reuseName(value())
    }

    @inlinable
    @discardableResult
    func reuseName(_ value: (Self) -> String?) -> Self {
        return self.reuseName(value(self))
    }
    
}
