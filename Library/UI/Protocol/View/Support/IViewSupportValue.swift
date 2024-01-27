//
//  KindKit
//

public protocol IViewSupportValue : AnyObject {
    
    associatedtype Value
    
    var value: Value { set get }
    
}

public extension IViewSupportValue {
    
    @inlinable
    @discardableResult
    func value(_ value: Value) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(on: () -> Value) -> Self {
        self.value = on()
        return self
    }

    @inlinable
    @discardableResult
    func value(on: (Self) -> Value) -> Self {
        self.value = on(self)
        return self
    }
    
}

public extension IViewSupportValue where Self : CompositorTrait, Body : IViewSupportValue {
    
    @inlinable
    var value: Body.Value {
        set { self.body.value = newValue }
        get { self.body.value }
    }
    
}
