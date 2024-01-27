//
//  KindKit
//

import KindProperty
import KindEvent
import KindMonadicMacro

@Monadic
public final class Condition< Request : KindPermission.Request > : KindProperty.Condition {
    
    public typealias Value = Bool
    
    public let scope: KindProperty.Scope
    
    public private(set) var value: Value {
        set {
            if self.scope.isUpdateLocked {
                self._scopeValue = newValue
            } else {
                self._value = newValue
            }
        }
        get {
            if let value = self._value {
                return value
            }
            let value: Bool
            if let status = self.permission.status {
                value = self.contains.contains(status)
            } else {
                value = false
            }
            self._value = value
            return value
        }
    }
    
    @MonadicField
    public var permission: Permission< Request > {
        willSet {
            guard self.permission !== newValue else { return }
            self.permission.onDidRequest(disconnect: self)
        }
        didSet {
            guard self.permission !== oldValue else { return }
            self.permission.onDidRequest(target: self, regular: { $0.requestChange() })
            self.requestChange()
        }
    }
    
    @MonadicField
    public var contains: [Status] {
        didSet {
            guard self.contains != oldValue else { return }
            self.requestChange()
        }
    }
    
    public let onChanged = Signal< Void, Change< Value > >()
    
    private var _value: Value? {
        didSet {
            guard self._value != oldValue else { return }
            self.onChanged.emit(.init(old: oldValue ?? self.value, new: self.value))
        }
    }
    private var _scopeValue: Value?

    public init(
        scope: KindProperty.Scope,
        permission: Permission< Request >,
        contains: [Status]
    ) {
        self.scope = scope
        self.permission = permission
        self.contains = contains
        if let status = permission.status {
            self._value = contains.contains(status)
        } else {
            self._value = false
        }

        self.scope.onCommit(target: self, regular: { $0._scopeCommit() })
        self.permission.onDidRequest(target: self, regular: { $0.requestChange() })
    }
    
    deinit {
        self.permission.onDidRequest(disconnect: self)
        self.scope.onCommit(disconnect: self)
    }
    
    public func requestChange() {
        guard self.scope.isUpdateLocked == false else { return }
        if let status = self.permission.status {
            self.value = self.contains.contains(status)
        }
    }
    
}

fileprivate extension Condition {
    
    func _scopeCommit() {
        guard let scopeValue = self._scopeValue else { return }
        self._scopeValue = nil
        self._value = scopeValue
    }
    
}
