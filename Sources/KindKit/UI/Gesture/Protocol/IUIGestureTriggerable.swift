//
//  KindKit
//

import Foundation

public protocol IUIGestureTriggerable : AnyObject {
    
    var onTriggered: Signal.Empty< Void > { get }
    
}

public extension IUIGestureTriggerable {
    
    @inlinable
    @discardableResult
    func onTriggered(_ closure: (() -> Void)?) -> Self {
        self.onTriggered.link(closure)
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
