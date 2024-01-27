//
//  KindKit
//

import KindCore
import KindEvent
import KindMonadicMacro

@Monadic
public final class Scope : @unchecked Sendable, BatchUpdateTrait {
    
    public var isUpdateLocked: Bool {
        return self._counter > 0
    }
    
    @MonadicSignal
    public let onLock = Signal< Void, Void >()
    
    @MonadicSignal
    public let onUnlock = Signal< Void, Void >()
    
    @MonadicSignal
    public let onCommit = Signal< Void, Void >()
    
    private var _counter = UInt.zero
    
    public init() {
    }
    
    @discardableResult
    public func lockUpdate() -> Self {
        self._counter += 1
        if self._counter == 1 {
            self.onLock.emit()
        }
        return self
    }
    
    @discardableResult
    public func unlockUpdate() -> Self {
        if self._counter == 1 {
            self.onUnlock.emit()
            self.update()
        } else if self._counter > 0 {
            self._counter -= 1
        }
        return self
    }
    
    @discardableResult
    public func update() -> Self {
        if self._counter == 0 {
            self.onCommit.emit()
        }
        return self
    }
    
}

public extension Scope {
    
    static let `default` = Scope()
    
}
