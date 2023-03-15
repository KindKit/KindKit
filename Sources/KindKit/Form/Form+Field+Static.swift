//
//  KindKit
//

import Foundation

public extension Form.Field {
    
    final class Static< Value : Equatable > : IFormField {
        
        public let id: Form.Id
        public var parent: IForm?
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
        public let valid: ICondition
        public var focusable: [IForm] {
            guard self.hidden() == false || self.locked() == false else {
                return []
            }
            if self.onFocus.isEmpty == false {
                return [ self ]
            }
            return []
        }
        public var result: [IFormResult] {
            guard self.valid() == true else {
                return []
            }
            return [
                Form.Result.Value(id: self.id, value: self.value)
            ]
        }
        public var onShouldFocus = Signal.Empty< Bool? >()
        public var onFocus = Signal.Empty< Void >()
        public var onChanged = Signal.Empty< Void >()
        public var value: Value {
            didSet {
                guard self.value != oldValue else { return }
                self.recursiveEmitOnChange()
            }
        }
        
        private let _mandatory: Condition.Optional
        private let _hidden: Condition.Optional
        private let _locked: Condition.Optional
        
        public init(
            id: Form.Id,
            value: Value
        ) {
            self.id = id
            self.value = value
            self._mandatory = .init(default: true)
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self.valid = .const(true)
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
        
        public func focus(after: IForm?) -> IForm? {
            guard self.hidden() == false && self.locked() == false else {
                return nil
            }
            if self.valid() == true {
                return nil
            }
            return self
        }
        
    }
    
}

private extension Form.Field.Static {
    
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

public extension Form.Field.Static {
    
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

extension Form.Field.Static : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self.onChanged.emit()
    }
    
}

public extension IFormField where Self == Form.Field.Static< Bool > {
    
    static func `static`(id: Form.Id, value: Bool) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< Int > {
    
    static func `static`(id: Form.Id, value: Int) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< UInt > {
    
    static func `static`(id: Form.Id, value: UInt) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< Float > {
    
    static func `static`(id: Form.Id, value: Float) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< Double > {
    
    static func `static`(id: Form.Id, value: Double) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< Date > {
    
    static func `static`(id: Form.Id, value: Date) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< String > {
    
    static func `static`(id: Form.Id, value: String) -> Self {
        return .init(id: id, value: value)
    }
    
}

public extension IFormField where Self == Form.Field.Static< URL > {
    
    static func `static`(id: Form.Id, value: URL) -> Self {
        return .init(id: id, value: value)
    }
    
}
