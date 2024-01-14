//
//  KindKit
//

import KindCore

public protocol IViewReusable : AnyObject {
    
    var reuseUnloadBehaviour: Reuse.UnloadBehaviour { set get }
    var reuseCache: ReuseCache? { set get }
    var reuseName: String? { set get }
    
}

public extension IViewReusable where Self : IWidgetView, Body : IViewReusable {
    
    @inlinable
    var reuseUnloadBehaviour: Reuse.UnloadBehaviour {
        set { self.body.reuseUnloadBehaviour = newValue }
        get { self.body.reuseUnloadBehaviour }
    }
    var reuseCache: ReuseCache? {
        set { self.body.reuseCache = newValue }
        get { self.body.reuseCache }
    }
    var reuseName: String? {
        set { self.body.reuseName = newValue }
        get { self.body.reuseName }
    }
    
}

public extension IViewReusable {
    
    @inlinable
    @discardableResult
    func reuseUnloadBehaviour(_ value: Reuse.UnloadBehaviour) -> Self {
        self.reuseUnloadBehaviour = value
        return self
    }
    
    @inlinable
    @discardableResult
    func reuseUnloadBehaviour(_ value: () -> Reuse.UnloadBehaviour) -> Self {
        return self.reuseUnloadBehaviour(value())
    }

    @inlinable
    @discardableResult
    func reuseUnloadBehaviour(_ value: (Self) -> Reuse.UnloadBehaviour) -> Self {
        return self.reuseUnloadBehaviour(value(self))
    }
    
    @inlinable
    @discardableResult
    func reuseCache(_ value: ReuseCache?) -> Self {
        self.reuseCache = value
        return self
    }
    
    @inlinable
    @discardableResult
    func reuseCache(_ value: () -> ReuseCache?) -> Self {
        return self.reuseCache(value())
    }

    @inlinable
    @discardableResult
    func reuseCache(_ value: (Self) -> ReuseCache?) -> Self {
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
