//
//  KindKit
//

import KindEvent
import KindTime

public protocol IAction : ICancellable {
    
    var state: State { get }
    
    var onStart: Signal< Void, Void > { get }
    
    var onFinish: Signal< Void, Bool > { get }
    
    func update(_ time: Interval< SecondUnit >) -> Result
    
}

public extension IAction {
    
    @inlinable
    @discardableResult
    func onStart(_ closure: @escaping() -> Void) -> Self {
        self.onStart.add(closure)
        return self
    }

    @inlinable
    @discardableResult
    func onStart(_ closure: @escaping(Self) -> Void) -> Self {
        self.onStart.add(self, closure)
        return self
    }

    @inlinable 
    @discardableResult
    func onStart<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
        self.onStart.add(target, closure)
        return self
    }

    @inlinable 
    @discardableResult
    func onStart(remove target: AnyObject) -> Self {
        self.onStart.remove(target)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping(Bool) -> Void) -> Self {
        self.onFinish.add(closure)
        return self
    }

    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping(Self, Bool) -> Void) -> Self {
        self.onFinish.add(self, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onFinish<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType, Bool) -> Void) -> Self where TargetType: AnyObject {
        self.onFinish.add(target, closure)
        return self
    }

    @inlinable
    @discardableResult
    func onFinish(remove target: AnyObject) -> Self {
        self.onFinish.remove(target)
        return self
    }
    
}
