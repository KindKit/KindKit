//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public final class ValueProperty< Value : Equatable > : Property {
    
    public let scope: Scope
    
    @MonadicField
    public var value: Value {
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
            self.onChanged.emit(.init(old: oldValue, new: self.value))
        }
    }
    private var _scopeValue: Value?

    public init(
        scope: Scope,
        value: Value
    ) {
        self.scope = scope
        self._value = value
        
        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
    }
    
    deinit {
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
    }
    
}

fileprivate extension ValueProperty {
    
    func _scopeCommit() {
        guard let scopeValue = self._scopeValue else { return }
        self._scopeValue = nil
        self._value = scopeValue
    }
    
}
