//
//  KindKit
//

import Foundation

public protocol ITimerWithEnding : ITimer {
    
    var isFinished: Bool { get }
    
    var onFinished: Signal.Empty< Void > { get }
    
}

public extension ITimerWithEnding {
    
    @inlinable
    @discardableResult
    func onFinished(_ value: (() -> Void)?) -> Self {
        self.onFinished.link(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinished(_ closure: @escaping (Self) -> Void) -> Self {
        self.onFinished.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinished< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onFinished.link(sender, closure)
        return self
    }
    
}
