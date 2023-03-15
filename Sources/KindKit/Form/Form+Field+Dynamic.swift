//
//  KindKit
//

import Foundation

public extension Form.Field {
    
    final class Dynamic< Value : Equatable > : IFormField {
        
        public typealias ValidatorClosure = (Value) -> Bool
        
        public let id: Form.Id
        public weak var parent: IForm?
        public var mandatory: ICondition {
            set { self._mandatory.condition = newValue }
            get { return self._mandatory }
        }
        public var hidden: ICondition {
            set { self._hidden.condition = newValue }
            get { return self._hidden }
        }
        public var locked: ICondition {
            set { self._locked.condition = newValue }
            get { return self._locked }
        }
        public var valid: ICondition {
            return self._valid
        }
        public var focusable: [IForm] {
            guard self.hidden() == false || self.locked() == false else {
                return []
            }
            if self.shouldFocus == true {
                return [ self ]
            }
            return []
        }
        public var result: [IFormResult] {
            guard self.hidden() == false else {
                return []
            }
            return [
                Form.Result.Value(id: self.id, value: self.value)
            ]
        }
        public var onShouldFocus = Signal.Empty< Bool? >()
        public var onFocus = Signal.Empty< Void >()
        public var onChanged = Signal.Empty< Void >()
        public var validator: ValidatorClosure? {
            set { self._valid.validator = newValue }
            get { self._valid.validator }
        }
        public var value: Value {
            set {
                guard self._valid.value != newValue else { return }
                self._valid.value = newValue
                self.recursiveEmitOnChange()
            }
            get { self._valid.value }
        }
        
        private let _mandatory: Condition.Optional
        private let _hidden: Condition.Optional
        private let _locked: Condition.Optional
        private let _valid: Valid
        
        public init(
            id: Form.Id,
            value: Value
        ) {
            self.id = id
            self._mandatory = .init(default: false)
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self._valid = .init(
                mandatory: self._mandatory,
                hidden: self._hidden,
                locked: self._locked,
                value: value
            )
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func find(by id: Form.Id) -> IForm? {
            if self.id == id {
                return self
            }
            return nil
        }
        
    }
    
}

private extension Form.Field.Dynamic {
    
    func _setup() {
        self.mandatory.add(observer: self, priority: .internal)
        self.hidden.add(observer: self, priority: .internal)
        self.locked.add(observer: self, priority: .internal)
        self.valid.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.mandatory.remove(observer: self)
        self.hidden.remove(observer: self)
        self.locked.remove(observer: self)
        self.valid.remove(observer: self)
    }
    
}

public extension Form.Field.Dynamic {
    
    @inlinable
    @discardableResult
    func validator(_ value: ValidatorClosure?) -> Self {
        self.validator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func validator(_ value: () -> ValidatorClosure?) -> Self {
        return self.validator(value())
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Value) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> Value) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> Value) -> Self {
        return self.value(value(self))
    }
    
}

extension Form.Field.Dynamic : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self.onChanged.emit()
    }
    
}

public extension IFormField where Self == Form.Field.Dynamic< String > {
    
    static func dynamic(id: Form.Id, value: String) -> Self {
        return .init(id: id, value: value)
    }
    
}
