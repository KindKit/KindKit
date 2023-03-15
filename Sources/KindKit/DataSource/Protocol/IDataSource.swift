//
//  KindKit
//

import Foundation

public protocol IDataSource : ICancellable {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >
    
    var result: Result? { get }
    var onFinish: Signal.Args< Void, Result > { get }
    
}

public extension IDataSource {
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: ((Result) -> Void)?) -> Self {
        self.onFinish.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish(_ closure: @escaping (Self, Result) -> Void) -> Self {
        self.onFinish.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinish< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Result) -> Void) -> Self {
        self.onFinish.link(sender, closure)
        return self
    }
    
}
