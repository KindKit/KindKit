//
//  KindKit
//

import KindCore

public final class Signal< Result, Argument > {
    
    public typealias Callback = KindEvent.Callback< Result, Argument >
    
    public var isEmpty: Bool {
        return self.slots.isEmpty == true
    }
    var slots: [Callback] = []
    
    private var _isEmitting: Bool = false
    private var _disconnectQueue: [Callback] = []
    
    public init() {
    }
    
    deinit {
        self.disconnect()
    }
    
}

extension Signal : @unchecked Sendable {
}

extension Signal : UnsubscribeTrait {
    
    public func unsubscribe(_ object: CancelTrait) {
        guard let index = self.slots.firstIndex(where: { $0 === object }) else { return }
        self.slots.remove(at: index)
    }
    
}

public extension Signal {
    
    func connect(_ slot: Callback) -> CancelTrait {
        self.slots.append(slot)
        return slot.source(self)
    }
    
}

public extension Signal {
    
    @discardableResult
    func connect(regular closure: @escaping () -> Result) -> CancelTrait {
        return self.connect(RegularCallback(
            callback: closure
        ))
    }
    
    @discardableResult
    func connect(regular closure: @escaping (Argument) -> Result) -> CancelTrait {
        return self.connect(RegularCallback(
            callback: closure
        ))
    }
    
    @discardableResult
    func connect< Target : AnyObject >(
        capture: Capture< Target, Result >,
        regular closure: @escaping (Target, Argument) -> Result
    ) -> CancelTrait {
        return self.connect(RegularTargetCallback(
            capture: capture,
            callback: closure
        ))
    }
    
    @discardableResult
    func connect< Target : AnyObject >(
        capture: Capture< Target, Result >,
        regular closure: @escaping (Target) -> Result
    ) -> CancelTrait {
        return self.connect(RegularTargetCallback(
            capture: capture,
            callback: closure
        ))
    }
    
}

public extension Signal {
    
    @discardableResult
    func connect(once closure: @escaping () -> Result) -> CancelTrait {
        return self.connect(OnceCallback(
            callback: closure
        ))
    }
    
    @discardableResult
    func connect(once closure: @escaping (Argument) -> Result) -> CancelTrait {
        return self.connect(OnceCallback(
            callback: closure
        ))
    }
    
    @discardableResult
    func connect< Target : AnyObject >(
        capture: Capture< Target, Result >,
        once closure: @escaping (Target, Argument) -> Result
    ) -> CancelTrait {
        return self.connect(OnceTargetCallback(
            capture: capture,
            callback: closure
        ))
    }
    
    @discardableResult
    func connect< Target : AnyObject >(
        capture: Capture< Target, Result >,
        once closure: @escaping (Target) -> Result
    ) -> CancelTrait {
        return self.connect(OnceTargetCallback(
            capture: capture,
            callback: closure
        ))
    }
    
}

public extension Signal {
    
    func disconnect(_ target: AnyObject) {
        if self._isEmitting == true {
            self._disconnectQueue.append(
                contentsOf: self.slots.filter({ $0.contains(target) })
            )
        } else {
            self.slots.removeAll(where: { $0.contains(target) })
        }
    }
    
    func disconnect() {
        for slot in self.slots {
            slot.reset()
        }
    }
    
}

fileprivate extension Signal {
    
    @inline(__always)
    func _emit< Output >(_ closure: () -> Output) -> Output {
        self._isEmitting = true
        defer {
            if self._disconnectQueue.isEmpty == false {
                self.slots.removeAll(where: { slot in
                    self._disconnectQueue.contains(where: { slot === $0 })
                })
                self._disconnectQueue.removeAll(keepingCapacity: true)
            }
            self._isEmitting = false
        }
        return closure()
    }
    
}

public extension Signal where Result == Void {
    
    func emit() where Argument == Void {
        self.emit(())
    }
    
    func emit(_ argument: Argument) {
        guard self._isEmitting == false else { return }
        self._emit({
            for slot in self.slots {
                slot.perform(argument)
            }
        })
    }
    
}

public extension Signal where Result : OptionalTrait {
    
    func emit() -> Result.Wrapped? where Argument == Void {
        return self.emit(())
    }
    
    func emit(_ argument: Argument) -> Result.Wrapped? {
        guard self._isEmitting == false else { return nil }
        return self._emit({
            for slot in self.slots {
                if let value = slot.perform(argument).asOptional {
                    return value
                }
            }
            return nil
        })
    }
    
    func emit(default: () -> Result.Wrapped) -> Result.Wrapped where Argument == Void {
        return self.emit((), default: `default`)
    }
    
    func emit(_ argument: Argument, default: () -> Result.Wrapped) -> Result.Wrapped {
        if let result = self.emit(argument) {
            return result
        }
        return `default`()
    }
    
    func emit(default: @autoclosure () -> Result.Wrapped) -> Result.Wrapped where Argument == Void {
        return self.emit((), default: `default`)
    }
    
    func emit(_ argument: Argument, default: @autoclosure () -> Result.Wrapped) -> Result.Wrapped {
        if let result = self.emit(argument) {
            return result
        }
        return `default`()
    }
    
}

