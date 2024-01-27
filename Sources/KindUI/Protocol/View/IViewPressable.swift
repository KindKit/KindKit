//
//  KindKit
//

import KindEvent

public protocol IViewPressable : AnyObject {
    
    var shouldPress: Bool { set get }
    
    var onPress: Signal< Void, Void > { get }
    
}

public extension IViewPressable where Self : IComposite, BodyType : IViewPressable {
    
    @inlinable
    var shouldPress: Bool {
        set { self.body.shouldPress = newValue }
        get { self.body.shouldPress }
    }
    
    @inlinable
    var onPress: Signal< Void, Void > {
        self.body.onPress
    }
    
}

public extension IViewPressable {
    
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

public extension IViewPressable {
    
    @inlinable
    @discardableResult
    func onPress(_ closure: @escaping () -> Void) -> Self {
        self.onPress.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPress(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPress.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPress< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
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
