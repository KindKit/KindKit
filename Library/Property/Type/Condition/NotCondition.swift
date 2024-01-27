//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public final class NotCondition< Condition : KindProperty.Condition > : KindProperty.Condition {
    
    public typealias Value = Bool
    
    public let scope: Scope
    
    @MonadicField
    public var condition: Condition {
        willSet {
            self.condition.onChanged(disconnect: self)
        }
        didSet {
            self.condition.onChanged(target: self, regular: { $0.requestChange() })
            self.requestChange()
        }
    }
    
    public private(set) var value: Value {
        set {
            if self.scope.isUpdateLocked {
                self._scopeValue = newValue
            } else {
                self._value = newValue
            }
        }
        get {
            return self._value
        }
    }
    
    public let onChanged = Signal< Void, Change< Value > >()
    
    private var _value: Value {
        didSet {
            guard self._value.isNotEqual(oldValue) else { return }
            self.onChanged.emit(.init(old: oldValue, new: self._value))
        }
    }
    private var _scopeValue: Value?
    
    public init(
        scope: Scope,
        condition: Condition
    ) {
        self.scope = scope
        self.condition = condition
        self._value = Self.get(condition)
        
        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
        self.condition.onChanged(target: self, regular: { $0.requestChange() })
    }
    
    deinit {
        self.condition.onChanged(disconnect: self)
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
        guard self.scope.isUpdateLocked == false else { return }
        self.condition.requestChange()
    }
    
}

fileprivate extension NotCondition {
    
    @inline(__always)
    static func get(_ wrapped: Condition) -> Value {
        return !wrapped.value
    }
    
    func _scopeCommit() {
        guard let scopeValue = self._scopeValue else { return }
        self._scopeValue = nil
        self._value = scopeValue
    }
    
}
