//
//  KindKit
//

import Foundation
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
    func onStarted< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onStarted.add(target, closure)
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
    func onTriggered< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onTriggered.add(target, closure)
        return self
    }
    
}
