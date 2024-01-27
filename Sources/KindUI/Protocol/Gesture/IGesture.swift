//
//  KindKit
//

#if os(iOS)
import UIKit
#endif
import KindEvent
import KindMath

public protocol IGesture : AnyObject {
    
    var owned: (any IView)? { set get }
    
    var handle: NativeGesture { get }
    
    var isLoaded: Bool { get }
    
    var isEnabled: Bool { set get }
    
#if os(iOS)
    
    var cancelsInView: Bool { set get }
    
    var delaysBegan: Bool { set get }
    
    var delaysEnded: Bool { set get }
    
    var requiresExclusive: Bool { set get }
        
#endif
    
    var onShouldBegin: Signal< Bool?, Void > { get }
    
    var onShouldSimultaneously: Signal< Bool?, NativeGesture > { get }
    
    var onShouldRequireFailure: Signal< Bool?, NativeGesture > { get }
    
    var onShouldBeRequiredToFailBy: Signal< Bool?, NativeGesture > { get }
    
}

public extension IGesture {

    func contains(
        in view: any IView,
        inset: Inset = .zero
    ) -> Bool {
        let location = self.location(in: view)
        let bounds = view.bounds.inset(-inset)
        return bounds.isContains(location)
    }

    func location(in view: any IView) -> Point {
        return Point(self.handle.location(in: view.handle))
    }

}

public extension IGesture {
    
    @inlinable
    var enabled: Bool {
        set { self.isEnabled = newValue }
        get { self.isEnabled }
    }
    
    @inlinable
    @discardableResult
    func enabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func enabled(_ value: () -> Bool) -> Self {
        self.isEnabled = value()
        return self
    }
    
    @inlinable
    @discardableResult
    func enabled(_ value: (Self) -> Bool) -> Self {
        self.isEnabled = value(self)
        return self
    }
    
}

#if os(iOS)

public extension IGesture {
    
    @inlinable
    func require(toFail gesture: IGesture) {
        self.require(toFail: gesture.handle)
    }
    
    @inlinable
    func require(toFail gesture: NativeGesture) {
        self.handle.require(toFail: gesture)
    }
    
}

public extension IGesture {
    
    @inlinable
    @discardableResult
    func cancelsInView(_ value: Bool) -> Self {
        self.cancelsInView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func cancelsInView(_ value: () -> Bool) -> Self {
        return self.cancelsInView(value())
    }

    @inlinable
    @discardableResult
    func cancelsInView(_ value: (Self) -> Bool) -> Self {
        return self.cancelsInView(value(self))
    }
    
    @inlinable
    @discardableResult
    func delaysBegan(_ value: Bool) -> Self {
        self.delaysBegan = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysBegan(_ value: () -> Bool) -> Self {
        return self.delaysBegan(value())
    }

    @inlinable
    @discardableResult
    func delaysBegan(_ value: (Self) -> Bool) -> Self {
        return self.delaysBegan(value(self))
    }
    
    @inlinable
    @discardableResult
    func delaysEnded(_ value: Bool) -> Self {
        self.delaysEnded = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysEnded(_ value: () -> Bool) -> Self {
        return self.delaysEnded(value())
    }

    @inlinable
    @discardableResult
    func delaysEnded(_ value: (Self) -> Bool) -> Self {
        return self.delaysEnded(value(self))
    }
    
    @inlinable
    @discardableResult
    func requiresExclusive(_ value: Bool) -> Self {
        self.requiresExclusive = value
        return self
    }
    
    @inlinable
    @discardableResult
    func requiresExclusive(_ value: () -> Bool) -> Self {
        return self.requiresExclusive(value())
    }

    @inlinable
    @discardableResult
    func requiresExclusive(_ value: (Self) -> Bool) -> Self {
        return self.requiresExclusive(value(self))
    }
    
}

#endif

public extension IGesture {
    
    @inlinable
    @discardableResult
    func onShouldBegin(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldBegin.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldBegin.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Bool?) -> Self {
        self.onShouldBegin.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBegin(remove target: AnyObject) -> Self {
        self.onShouldBegin.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldSimultaneously.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping (NativeGesture) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(_ closure: @escaping (Self, NativeGesture) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, NativeGesture) -> Bool?) -> Self {
        self.onShouldSimultaneously.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldSimultaneously(remove target: AnyObject) -> Self {
        self.onShouldSimultaneously.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldRequireFailure.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping (NativeGesture) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping (Self, NativeGesture) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, NativeGesture) -> Bool?) -> Self {
        self.onShouldRequireFailure.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldRequireFailure(remove target: AnyObject) -> Self {
        self.onShouldRequireFailure.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping () -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping (NativeGesture) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(_ closure: @escaping (Self, NativeGesture) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, NativeGesture) -> Bool?) -> Self {
        self.onShouldBeRequiredToFailBy.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldBeRequiredToFailBy(remove target: AnyObject) -> Self {
        self.onShouldBeRequiredToFailBy.remove(target)
        return self
    }
    
}
