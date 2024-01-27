//
//  KindKit
//

import KindProperty
import KindEvent
import KindMonadicMacro

@Monadic
public final class ListField : Field, MandatoryFieldTrait {
    
    public var id: Id
    
    public let formProperty: ParentFormProperty
    
    public let parentProperty: ParentFieldProperty
    
    public let pathProperty: PathProperty
    
    public let hiddenProperty: ValueProperty< Bool >
    
    public let lockedProperty: ValueProperty< Bool >
    
    public let focusFieldsProperty: AnyProperty< [any Field] >
    
    public let shouldFocusProperty: ValueProperty< Bool >
    
    public let focusProperty: ValueProperty< Focus >
    
    public let validProperty: AnyProperty< Bool >
    
    public let resultProperty: AnyProperty< (any Record)? >
    
    public let mandatoryProperty: ValueProperty< Bool >
    
    @MonadicField
    public var policy: SequencePolicy = .all {
        didSet {
            guard self.policy != oldValue else { return }
            if self.fieldsProperty.value.isEmpty == false {
                self._validProperty.requestChange()
            }
        }
    }
    
    @MonadicField
    public var fields: [any Field] {
        set { self.fieldsProperty.value = newValue }
        get { self.fieldsProperty.value }
    }
    
    public let fieldsProperty: FieldsProperty
    
    private let _focusFieldsProperty: LazyProperty< [any Field] >
    private let _focusFieldsCallback: OptionalCallback< [any Field], Void >
    
    private let _validProperty: LazyProperty< Bool >
    private let _validCallback: OptionalCallback< Bool, Void >
    
    private let _resultProperty: LazyProperty< (any Record)? >
    private let _resultCallback: OptionalCallback< (any Record)?, Void >
    
    public init(
        scope: Scope,
        id: Id
    ) {
        self.id = id
        self.formProperty = .init(scope: scope)
        self.parentProperty = .init(scope: scope)
        self.pathProperty = .init(scope: scope, id: id, parent: self.parentProperty)
        self.mandatoryProperty = .init(scope: scope, value: false)
        self.hiddenProperty = .init(scope: scope, value: false)
        self.lockedProperty = .init(scope: scope, value: false)
        self.fieldsProperty = .init(scope: scope)
        do {
            self.shouldFocusProperty = .init(scope: scope, value: false)
            self._focusFieldsCallback = .init(default: [])
            self._focusFieldsProperty = .init(
                scope: scope,
                dependencies: [ self.hiddenProperty, self.lockedProperty, self.shouldFocusProperty ],
                callback: self._focusFieldsCallback
            )
            self.focusFieldsProperty = .init(self._focusFieldsProperty)
            self.focusProperty = .init(scope: scope, value: .inactive)
        }
        do {
            self._validCallback = .init(default: true)
            self._validProperty = .init(
                scope: scope,
                dependencies: [ self.mandatoryProperty ],
                callback: self._validCallback
            )
            self.validProperty = .init(self._validProperty)
        }
        do {
            self._resultCallback = .init()
            self._resultProperty = .init(
                scope: scope,
                dependencies: [ self.validProperty ],
                callback: self._resultCallback
            )
            self.resultProperty = .init(self._resultProperty)
        }
        
        self._setup()
    }
    
    public func first(by id: Id) -> (any Field)? {
        if self.id == id {
            return self
        }
        for field in self.fields {
            if let first = field.first(by: id) {
                return first
            }
        }
        return nil
    }
    
}

fileprivate extension ListField {
    
    func _setup() {
        self.formProperty.onChanged(
            target: self,
            regular: { target, change in
                if let form = change.old {
                    target._onDettach(form: form)
                }
                if let form = change.new {
                    target._onAttach(form: form)
                }
            }
        )
        
        self._focusFieldsCallback.callback = RegularTargetCallback(
            capture: .weak(self, default: []),
            callback: { target in
                guard target.isHidden == false else { return [] }
                guard target.isLocked == false else { return [] }
                var fields: [any Field] = []
                if target.shouldFocus == true {
                    fields.append(target)
                }
                for field in target.fields {
                    fields.append(contentsOf: field.focusFields)
                }
                return fields
            }
        )
        
        self.focusProperty.onChanged(
            target: self,
            regular: { $0._onChangedFocus() }
        )
        
        self.fieldsProperty.onChanged(
            target: self,
            regular: { target, change in
                let diff = change.old.kk_difference(change.new, where: { $0 === $1 })
                for field in diff.removed {
                    target._focusFieldsProperty.remove(dependency: field.focusFieldsProperty)
                    target._validProperty.remove(dependency: field.validProperty)
                    target._resultProperty.remove(dependency: field.resultProperty)
                    field.parent = nil
                    field.form = nil
                }
                for field in diff.added {
                    target._focusFieldsProperty.append(dependency: field.focusFieldsProperty)
                    target._validProperty.append(dependency: field.validProperty)
                    target._resultProperty.append(dependency: field.resultProperty)
                    field.parent = target
                    field.form = target.form
                }
            }
        )
        
        self._validCallback.callback = RegularTargetCallback(
            capture: .weak(self, default: false),
            callback: { target in
                guard target.isHidden == false && target.isLocked == false else { return false }
                guard target.isMandatory == true else { return true }
                return target.policy.check(fields: target.fields)
            }
        )
        
        self._resultCallback.callback = RegularTargetCallback(
            capture: .weak(self),
            callback: { target in
                guard target.isValid == true else { return nil }
                return SequenceRecord(
                    id: target.id,
                    records: target.fields.compactMap(\.result)
                )
            }
        )
    }
    
    func _onAttach(form: Form) {
        for field in self.fields {
            field.form = form
        }
        if self.focus == .active {
            form.focus = self
        }
    }
    
    func _onDettach(form: Form) {
        for field in self.fields {
            field.form = nil
        }
    }
    
    func _onChangedFocus() {
        switch self.focus {
        case .inactive: self.form?.focus = nil
        case .active: self.form?.focus = self
        }
    }
    
}
