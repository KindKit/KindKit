//
//  KindKit
//

import Foundation

public extension Form.Field {
    
    final class Sequence : IFormField {
        
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
            var result: [IForm] = []
            if self.shouldFocus == true {
                result.append(self)
            }
            for item in self.items {
                result.append(contentsOf: item.focusable)
            }
            return result
        }
        public var result: [IFormResult] {
            guard self.hidden() == false else {
                return []
            }
            var buffer: [IFormResult] = []
            for value in self.items {
                buffer.append(contentsOf: value.result)
            }
            guard buffer.isEmpty == false else {
                return []
            }
            return [
                Form.Result.Sequence(id: self.id, value: buffer)
            ]
        }
        public var onShouldFocus = Signal.Empty< Bool? >()
        public var onFocus = Signal.Empty< Void >()
        public var onChanged = Signal.Empty< Void >()
        public var policy: Form.Field.Policy {
            set { self._valid.policy = newValue }
            get { return self._valid.policy  }
        }
        public var items: [IForm] {
            set {
                guard self._valid.items.elementsEqual(newValue, by: { $0 === $1 }) == false else {
                    return
                }
                for item in self._valid.items {
                    item.parent = nil
                }
                for item in newValue {
                    item.parent = self
                }
                self._valid.items = newValue
                self.onChanged.emit()
            }
            get {
                return self._valid.items
            }
        }
        
        private let _mandatory: Condition.Optional
        private let _hidden: Condition.Optional
        private let _locked: Condition.Optional
        private let _valid: Valid
        
        public init(
            id: Form.Id,
            policy: Form.Field.Policy
        ) {
            self.id = id
            self._mandatory = .init(default: false)
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self._valid = .init(
                policy: policy,
                mandatory: self._mandatory,
                hidden: self._hidden,
                locked: self._locked
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
            for item in self.items {
                if let value = item.find(by: id) {
                    return value
                }
            }
            return nil
        }
        
    }
    
}

private extension Form.Field.Sequence {
    
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

public extension Form.Field.Sequence {
    
    @inlinable
    func contains(item: IForm) -> Bool {
        return self.items.contains(where: { $0 === item })
    }
    
    @inlinable
    func index(item: IForm) -> Int? {
        return self.items.firstIndex(where: { $0 === item })
    }
    
    @inlinable
    @discardableResult
    func append(item: IForm) -> Self {
        if self.contains(item: item) == false {
            self.items.append(item)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func remove(item: IForm) -> Self {
        if let index = self.index(item: item) {
            self.items.remove(at: index)
        }
        return self
    }
    
}

public extension Form.Field.Sequence {
    
    @inlinable
    @discardableResult
    func policy(_ value: Form.Field.Policy) -> Self {
        self.policy = value
        return self
    }
    
    @inlinable
    @discardableResult
    func policy(_ value: () -> Form.Field.Policy) -> Self {
        return self.policy(value())
    }

    @inlinable
    @discardableResult
    func policy(_ value: (Self) -> Form.Field.Policy) -> Self {
        return self.policy(value(self))
    }
    
    @inlinable
    @discardableResult
    func items(_ value: [IForm]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [IForm]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [IForm]) -> Self {
        return self.items(value(self))
    }
    
}

extension Form.Field.Sequence : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self.onChanged.emit()
    }
    
}

public extension IForm where Self == Form.Field.Sequence {
    
    static func sequence(id: Form.Id, policy: Form.Field.Policy) -> Self {
        return .init(id: id, policy: policy)
    }
    
}
