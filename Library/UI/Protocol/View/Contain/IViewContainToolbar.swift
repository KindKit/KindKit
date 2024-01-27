//
//  KindKit
//

public protocol IViewContainToolbar : AnyObject {
    
#if os(iOS)
    
    var toolbar: ToolbarView? { set get }
    
#endif
    
}

#if os(iOS)

public extension IViewContainToolbar {
    
    @inlinable
    @discardableResult
    func toolbar(_ value: ToolbarView?) -> Self {
        self.toolbar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(on: () -> ToolbarView?) -> Self {
        self.toolbar = on()
        return self
    }

    @inlinable
    @discardableResult
    func toolbar(on: (Self) -> ToolbarView?) -> Self {
        self.toolbar = on(self)
        return self
    }
    
}

public extension IViewContainToolbar where Self : IComposite, Body : IViewContainToolbar {
    
#if os(iOS)
    
    @inlinable
    var toolbar: ToolbarView? {
        set { self.body.toolbar = newValue }
        get { self.body.toolbar }
    }
    
#endif
    
}

#endif
