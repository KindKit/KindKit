//
//  KindKit
//

import KindEvent

public protocol IEntity : ICancellable {
    
    var queue: DispatchQueue { get }
    
    var isRunning: Bool { get }
    
    var onStarted: Signal< Void, Void > { get }
    var onTriggered: Signal< Void, Void > { get }
    
}

public extension IEntity {
    
    @inlinable
    @discardableResult
    func onStarted(_ value: @escaping () -> Void) -> Self {
        self.onStarted.add(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStarted(_ closure: @escaping (Self) -> Void) -> Self {
        self.onStarted.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStarted< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onStarted.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ value: @escaping () -> Void) -> Self {
        self.onTriggered.add(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: @escaping (Self) -> Void) -> Self {
        self.onTriggered.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onTriggered.add(sender, closure)
        return self
    }
    
}
