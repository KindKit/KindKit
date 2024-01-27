//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public final class OptionalProperty< Property : KindProperty.Property > : KindProperty.Property {

    public typealias Value = Property.Value?
    
    public let scope: Scope

    @MonadicField
    public var property: Property? {
        didSet {
            guard self.property !== oldValue else { return }
            if let property = oldValue {
                property.onChanged(disconnect: self)
                if self.scope.isUpdateLocked {
                    property.unlockScope()
                }
            }
            if let property = self.property {
                if self.scope.isUpdateLocked {
                    property.lockScope()
                }
                property.onChanged(target: self, regular: {
                    $0.value = $0.property?.value
                })
                self.value = property.value
            } else {
                self.value = nil
            }
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
    
    private var _value: Value = nil {
        didSet { self.onChanged.emit(.init(old: oldValue, new: self.value)) }
    }
    private var _scopeValue: Value?

    public init(
        scope: Scope = .default
    ) {
        self.scope = scope
        
        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
    }
    
    deinit {
        self.property?.onChanged(disconnect: self)
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
        guard self.scope.isUpdateLocked == false else { return }
        self.property?.requestChange()
    }
    
}

fileprivate extension OptionalProperty {
    
    func _scopeCommit() {
        guard let scopeValue = self._scopeValue else { return }
        self._scopeValue = nil
        self._value = scopeValue
    }
    
}
