//
//  KindKit
//

import KindProperty
import KindEvent

public final class SelectField< Value : Equatable > : Field, SelectedFieldTrait, ValueFieldTrait {
    
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
    
    public let selectedProperty: ValueProperty< Bool >
    
    public let valueProperty: ValueProperty< Value >
    
    private let _focusFieldsProperty: LazyProperty< [any Field] >
    private let _focusFieldsCallback: OptionalCallback< [any Field], Void >
    
    private let _validProperty: LazyProperty< Bool >
    private let _validCallback: OptionalCallback< Bool, Void >
    
    private let _resultProperty: LazyProperty< (any Record)? >
    private let _resultCallback: OptionalCallback< (any Record)?, Void >
    
    public init(
        scope: Scope,
        id: Id,
        value: Value
    ) {
        self.id = id
        self.formProperty = .init(scope: scope)
        self.parentProperty = .init(scope: scope)
        self.pathProperty = .init(scope: scope, id: id, parent: self.parentProperty)
        self.hiddenProperty = .init(scope: scope, value: false)
        self.lockedProperty = .init(scope: scope, value: false)
        self.selectedProperty = .init(scope: scope, value: false)
        self.valueProperty = .init(scope: scope, value: value)
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
                dependencies: [ self.hiddenProperty, self.lockedProperty, self.selectedProperty ],
                callback: self._validCallback
            )
            self.validProperty = .init(self._validProperty)
        }
        do {
            self._resultCallback = .init()
            self._resultProperty = .init(
                scope: scope,
                dependencies: [ self.validProperty, self.valueProperty ],
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
        return nil
    }
    
}

fileprivate extension SelectField {
    
    func _setup() {
        self.formProperty.onChanged(
            target: self,
            regular: { target, change in
                if let form = change.new {
                    target._onAttach(form: form)
                }
            }
        )
        
        self._focusFieldsCallback.callback = RegularTargetCallback(
            capture: .weak(self, default: []),
            callback: { target in
                guard target.isHidden == false && target.isLocked == false else { return [] }
                guard target.shouldFocus == true else { return [] }
                return [ target ]
            }
        )
        
        self.focusProperty.onChanged(
            target: self,
            regular: { $0._onChangedFocus() }
        )
        
        self._validCallback.callback = RegularTargetCallback(
            capture: .weak(self, default: false),
            callback: { target in
                guard target.isHidden == false && target.isLocked == false else { return false }
                return target.isSelected
            }
        )
        
        self._resultCallback.callback = RegularTargetCallback(
            capture: .weak(self),
            callback: { target in
                guard target.isValid == true else { return nil }
                return ValueRecord(
                    id: target.id,
                    value: target.value
                )
            }
        )
    }
    
    func _onAttach(form: Form) {
        if self.focus == .active {
            form.focus = self
        }
    }
    
    func _onChangedFocus() {
        switch self.focus {
        case .inactive: self.form?.focus = nil
        case .active: self.form?.focus = self
        }
    }
    
}
