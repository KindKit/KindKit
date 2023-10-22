//
//  KindKit
//

import Foundation

public protocol ITimer : ICancellable {
    
    var queue: DispatchQueue { get }
    
    var isRunning: Bool { get }
    
    var onStarted: Signal.Empty< Void > { get }
    var onTriggered: Signal.Empty< Void > { get }
    
}

public extension ITimer {
    
    @inlinable
    @discardableResult
    func onStarted(_ value: (() -> Void)?) -> Self {
        self.onStarted.link(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStarted(_ closure: @escaping (Self) -> Void) -> Self {
        self.onStarted.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStarted< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onStarted.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ value: (() -> Void)?) -> Self {
        self.onTriggered.link(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: @escaping (Self) -> Void) -> Self {
        self.onTriggered.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onTriggered.link(sender, closure)
        return self
    }
    
}
