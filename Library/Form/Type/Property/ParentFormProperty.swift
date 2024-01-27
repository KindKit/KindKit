//
//  KindKit
//

import KindProperty
import KindEvent
import KindMonadicMacro

@Monadic
public final class ParentFormProperty : Property {
    
    public typealias Value = Form?
    
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
    
    private weak var _value: Value = nil {
        didSet {
            guard self._value !== oldValue else { return }
            self.onChanged.emit(.init(old: oldValue, new: self._value))
        }
    }
    private var _scopeValue: Value = nil
    
    public init(
        scope: Scope
    ) {
        self.scope = scope
        
        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
    }
    
    deinit {
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
    }
    
}

fileprivate extension ParentFormProperty {
    
    func _scopeCommit() {
        guard let scopeValue = self._scopeValue else { return }
        self._scopeValue = nil
        self._value = scopeValue
    }
    
}
