//
//  KindKit
//

import KindEvent

public protocol IGestureTriggerable : AnyObject {
    
    var onTriggered: Signal< Void, Void > { get }
    
}

public extension IGestureTriggerable {
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: @escaping () -> Void) -> Self {
        self.onTriggered.add(closure)
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
