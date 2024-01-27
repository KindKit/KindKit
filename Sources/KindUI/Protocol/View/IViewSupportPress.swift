//
//  KindKit
//

import KindEvent

public protocol IViewSupportPress : AnyObject {
    
    var shouldPress: Bool { set get }
    
    var availableMouseButtons: [Mouse.Button] { set get }
    
    var onPress: Signal< Void, Press > { get }
    
}

public extension IViewSupportPress where Self : IComposite, BodyType : IViewSupportPress {
    
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

public extension IViewSupportPress {
    
    @inlinable
    @discardableResult
    func shouldPress(_ value: Bool) -> Self {
        self.shouldPress = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldPress(_ value: () -> Bool) -> Self {
        return self.shouldPress(value())
    }

    @inlinable
    @discardableResult
    func shouldPress(_ value: (Self) -> Bool) -> Self {
        return self.shouldPress(value(self))
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
    func availableMouseButtons(_ value: () -> [Mouse.Button]) -> Self {
        return self.availableMouseButtons(value())
    }

    @inlinable
    @discardableResult
    func availableMouseButtons(_ value: (Self) -> [Mouse.Button]) -> Self {
        return self.availableMouseButtons(value(self))
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
    func onPress< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, Press) -> Void) -> Self {
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
