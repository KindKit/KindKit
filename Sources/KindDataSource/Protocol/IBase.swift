//
//  KindKit
//

import KindEvent

public protocol IBase : ICancellable {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >
    
    var result: Result? { get }
    var onFinish: Signal< Void, Result > { get }
    
}

public extension IBase {
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (Result) -> Void) -> Self {
        self.onFinish.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (Self, Result) -> Void) -> Self {
        self.onFinish.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, Result) -> Void) -> Self {
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
