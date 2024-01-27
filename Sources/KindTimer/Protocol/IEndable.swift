//
//  KindKit
//

import KindEvent

public protocol IEndable : AnyObject {
    
    var isFinished: Bool { get }
    
    var onFinished: Signal< Void, Void > { get }
    
}

public extension IEndable {
    
    @inlinable
    @discardableResult
    func onFinished(_ value: @escaping () -> Void) -> Self {
        self.onFinished.add(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinished(_ closure: @escaping (Self) -> Void) -> Self {
        self.onFinished.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinished< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType) -> Void) -> Self {
        self.onFinished.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onFinished(remove target: AnyObject) -> Self {
        self.onFinished.remove(target)
        return self
    }
    
}
