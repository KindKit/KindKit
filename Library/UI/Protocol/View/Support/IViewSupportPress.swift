//
//  KindKit
//

import KindEvent

public protocol IViewSupportPress : AnyObject {
    
    var shouldPress: Bool { set get }
    
    var availableMouseButtons: [Mouse.Button] { set get }
    
    var onPress: Signal< Void, Press > { get }
    
}

public extension IViewSupportPress {
    
    @inlinable
    @discardableResult
    func shouldPress(_ value: Bool) -> Self {
        self.shouldPress = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldPress(on: () -> Bool) -> Self {
        self.shouldPress = on()
        return self
    }

    @inlinable
    @discardableResult
    func shouldPress(on: (Self) -> Bool) -> Self {
        self.shouldPress = on(self)
        return self
    }
    
}

public extension IViewSupportPress {
    
    @inlinable
    @discardableResult
    func availableMouseButtons(_ value: [Mouse.Button]) -> Self {
        self.availableMouseButtons = value
        return self
    }
    
    @inlinable
    @discardableResult
    func availableMouseButtons(on: () -> [Mouse.Button]) -> Self {
        self.availableMouseButtons = on()
        return self
    }

    @inlinable
    @discardableResult
    func availableMouseButtons(on: (Self) -> [Mouse.Button]) -> Self {
        self.availableMouseButtons = on(self)
        return self
    }
    
}

public extension IViewSupportPress {
    
    @inlinable
    @discardableResult
    func onPress(_ closure: @escaping (Press) -> Void) -> Self {
        self.onPress.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPress(_ closure: @escaping (Self, Press) -> Void) -> Self {
        self.onPress.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPress< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target, Press) -> Void) -> Self {
        self.onPress.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPress(remove target: AnyObject) -> Self {
        self.onPress.remove(target)
        return self
    }
    
}

public extension IViewSupportPress where Self : CompositorTrait, Body : IViewSupportPress {
    
    @inlinable
    var shouldPress: Bool {
        set { self.body.shouldPress = newValue }
        get { self.body.shouldPress }
    }
    
    @inlinable
    var availableMouseButtons: [Mouse.Button] {
        set { self.body.availableMouseButtons = newValue }
        get { self.body.availableMouseButtons }
    }
    
    @inlinable
    var onPress: Signal< Void, Press > {
        self.body.onPress
    }
    
}
