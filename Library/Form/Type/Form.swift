//
//  KindKit
//

import KindProperty
import KindMonadicMacro

@Monadic
public final class Form {
    
    public let scope: Scope
    
    @inlinable
    @MonadicField
    public var root: (any Field)? {
        set { self.rootProperty.value = newValue }
        get { self.rootProperty.value }
    }
    
    public let rootProperty: FieldProperty
    
    @inlinable
    @MonadicField
    public var focus: (any Field)? {
        set { self.focusProperty.value = newValue }
        get { self.focusProperty.value }
    }
    
    public let focusProperty: FieldProperty
    
    public let validProperty: AnyProperty< Bool >
    
    public let resultProperty: AnyProperty< (any Record)? >
    
    private let _validProperty: LazyProperty< Bool >
    private let _validCallback: OptionalCallback< Bool, Void >
    
    private let _resultProperty: LazyProperty< (any Record)? >
    private let _resultCallback: OptionalCallback< (any Record)?, Void >
    
    public init(
        scope: Scope? = nil
    ) {
        if let scope = scope {
            self.scope = scope
        } else {
            self.scope = .init()
        }
        self.rootProperty = .init(scope: self.scope)
        self.focusProperty = .init(scope: self.scope)
        do {
            self._validCallback = .init(default: false)
            self._validProperty = .init(
                scope: self.scope,
                callback: self._validCallback
            )
            self.validProperty = .init(self._validProperty)
        }
        do {
            self._resultCallback = .init()
            self._resultProperty = .init(
                scope: self.scope,
                callback: self._resultCallback
            )
            self.resultProperty = .init(self._resultProperty)
        }
        
        self._setup()
    }
    
}

public extension Form {
    
    @inlinable
    var isValid: Bool {
        return self.validProperty.value
    }
    
    @inlinable
    var isNotValid: Bool {
        return !self.isValid
    }
    
    @inlinable
    var result: (any Record)? {
        return self.resultProperty.value
    }
    
}

public extension Form {
    
    @inlinable
    func first(by id: Id) -> (any Field)? {
        guard let root = self.root else { return nil }
        return root.first(by: id)
    }
    
    @inlinable
    func first(by path: Path) -> (any Field)? {
        guard let root = self.root else { return nil }
        return root.first(by: path)
    }
    
}

fileprivate extension Form {
    
    func _setup() {
        self.rootProperty.onChanged(target: self, regular: { target, change in
            if let field = change.old {
                field.form = nil
                target._validProperty.remove(dependency: field.validProperty)
                target._resultProperty.remove(dependency: field.resultProperty)
            }
            if let field = change.new {
                target._validProperty.append(dependency: field.validProperty)
                target._resultProperty.append(dependency: field.resultProperty)
                field.form = self
            }
        })
        self.focusProperty.onChanged(target: self, regular: { target, change in
            if let field = change.old {
                field.focus = .inactive
            }
            if let field = change.new {
                field.focus = .active
            }
        })
        self._validCallback.callback = RegularTargetCallback(
            capture: .weak(self, default: false),
            callback: { target in
                guard let root = target.root else { return true }
                return root.isValid
            }
        )
        self._resultCallback.callback = RegularTargetCallback(
            capture: .weak(self),
            callback: { target in
                guard let root = target.root else { return nil }
                return root.result
            }
        )
    }
    
}
