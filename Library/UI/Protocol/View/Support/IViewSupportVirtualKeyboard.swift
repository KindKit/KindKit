//
//  KindKit
//

public protocol IViewSupportVirtualKeyboard : AnyObject {
    
#if os(iOS)
    
    var virtualKeyboard: VirtualInput.Style? { set get }
    
#endif
    
}

#if os(iOS)

public extension IViewSupportVirtualKeyboard {
    
    @inlinable
    @discardableResult
    func virtualKeyboard(_ value: VirtualInput.Style?) -> Self {
        self.virtualKeyboard = value
        return self
    }
    
    @inlinable
    @discardableResult
    func virtualKeyboard(on: () -> VirtualInput.Style?) -> Self {
        self.virtualKeyboard = on()
        return self
    }

    @inlinable
    @discardableResult
    func virtualKeyboard(on: (Self) -> VirtualInput.Style?) -> Self {
        self.virtualKeyboard = on(self)
        return self
    }
    
}

public extension IViewSupportVirtualKeyboard where Self : IComposite, Body : IViewSupportVirtualKeyboard {
    
#if os(iOS)
    
    @inlinable
    var virtualKeyboard: VirtualInput.Style? {
        set { self.body.virtualKeyboard = newValue }
        get { self.body.virtualKeyboard }
    }
    
#endif
    
}

#endif
