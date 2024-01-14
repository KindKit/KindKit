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
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Result) -> Void) -> Self {
        self.onFinish.add(sender, closure)
        return self
    }
    
}
