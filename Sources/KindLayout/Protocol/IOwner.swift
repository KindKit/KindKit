//
//  KindKit
//

import KindEvent

public protocol IOwner : AnyObject, IBatchUpdate {
    
    var onLockUpdate: Signal< Void, Void > { get }
    
    var onUnlockUpdate: Signal< Void, Void > { get }
    
    var onInvalidate: Signal< Bool?, Void > { get }
    
    var onContentSize: Signal< Void, Void > { get }
    
    func invalidate()
    
    func remove(_ item: IItem)
    
}

public extension IOwner {
    
    @inlinable
    @discardableResult
    func onLockUpdate(_ closure: @escaping() -> Void) -> Self {
        self.onLockUpdate.add(closure)
        return self
    }

    @inlinable
    @discardableResult
    func onLockUpdate(_ closure: @escaping(Self) -> Void) -> Self {
        self.onLockUpdate.add(self, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onLockUpdate<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
        self.onLockUpdate.add(target, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onLockUpdate(remove target: AnyObject) -> Self {
        self.onLockUpdate.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onUnlockUpdate(_ closure: @escaping() -> Void) -> Self {
        self.onUnlockUpdate.add(closure)
        return self
    }

    @inlinable
    @discardableResult
    func onUnlockUpdate(_ closure: @escaping(Self) -> Void) -> Self {
        self.onUnlockUpdate.add(self, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onUnlockUpdate<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
        self.onUnlockUpdate.add(target, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onUnlockUpdate(remove target: AnyObject) -> Self {
        self.onUnlockUpdate.remove(target)
        return self
    }
    
    @inlinable 
    @discardableResult
    func onInvalidate(_ closure: @escaping() -> Bool?) -> Self {
        self.onInvalidate.add(closure)
        return self
    }

    @inlinable
    @discardableResult
    func onInvalidate(_ closure: @escaping(Self) -> Bool?) -> Self {
        self.onInvalidate.add(self, closure)
        return self
    }

    @inlinable 
    @discardableResult
    func onInvalidate<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Bool?) -> Self where TargetType: AnyObject {
        self.onInvalidate.add(target, closure)
        return self
    }

    @inlinable 
    @discardableResult
    func onInvalidate(remove target: AnyObject) -> Self {
        self.onInvalidate.remove(target)
        return self
    }

    @inlinable 
    @discardableResult 
    func onContentSize(_ closure: @escaping() -> Void) -> Self {
        self.onContentSize.add(closure)
        return self
    }

    @inlinable 
    @discardableResult 
    func onContentSize(_ closure: @escaping(Self) -> Void) -> Self {
        self.onContentSize.add(self, closure)
        return self
    }

    @inlinable 
    @discardableResult
    func onContentSize<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
        self.onContentSize.add(target, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onContentSize(remove target: AnyObject) -> Self {
        self.onContentSize.remove(target)
        return self
    }
    
}
