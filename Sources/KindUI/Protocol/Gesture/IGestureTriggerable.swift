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
    func onTriggered< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onTriggered.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTriggered(remove target: AnyObject) -> Self {
        self.onTriggered.remove(target)
        return self
    }
    
}
