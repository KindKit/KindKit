//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public protocol Property : AnyObject {
    
    associatedtype Value
    
    var scope: Scope { get }
    
    var value: Value { get }
    
    @MonadicSignal
    var onChanged: Signal< Void, Change< Value > > { get }
    
    func requestChange()
    
}

public extension Property {
    
    @inlinable
    @discardableResult
    func lockScope() -> Self {
        self.scope.lockUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func unlockScope() -> Self {
        self.scope.unlockUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func scope(`on` block: () -> Void) -> Self {
        self.scope.update(on: block)
        return self
    }
    
}
