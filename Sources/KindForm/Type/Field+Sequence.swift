//
//  KindKit
//

import KindCondition
import KindEvent

public extension Field {
    
    final class Sequence : IField {
        
        public let id: Id
        public weak var parent: IEntity?
        public var mandatory: KindCondition.IEntity {
            set { self._mandatory.condition = newValue }
            get { return self._mandatory }
        }
        public var hidden: KindCondition.IEntity {
            set { self._hidden.condition = newValue }
            get { return self._hidden }
        }
        public var locked: KindCondition.IEntity {
            set { self._locked.condition = newValue }
            get { return self._locked }
        }
        public var valid: KindCondition.IEntity {
            return self._valid
        }
        public var focusable: [IEntity] {
            guard self.hidden() == false || self.locked() == false else {
                return []
            }
            var result: [IEntity] = []
            if self.shouldFocus == true {
                result.append(self)
            }
            for item in self.items {
                result.append(contentsOf: item.focusable)
            }
            return result
        }
        public var result: [IResult] {
            guard self.hidden() == false else {
                return []
            }
            var buffer: [IResult] = []
            for value in self.items {
                buffer.append(contentsOf: value.result)
            }
            guard buffer.isEmpty == false else {
                return []
            }
            return [
                Result.Sequence(id: self.id, value: buffer)
            ]
        }
        public var onShouldFocus = Signal< Bool?, Void >()
        public var onFocus = Signal< Void, Void >()
        public var onChanged = Signal< Void, Void >()
        public var policy: Field.Policy {
            set { self._valid.policy = newValue }
            get { return self._valid.policy  }
        }
        public var items: [IEntity] {
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
        
        private let _mandatory: KindCondition.Optional
        private let _hidden: KindCondition.Optional
        private let _locked: KindCondition.Optional
        private let _valid: Valid
        
        public init(
            id: Id,
            policy: Field.Policy
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
        
        public func find(by id: Id) -> IEntity? {
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

private extension Field.Sequence {
    
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

public extension Field.Sequence {
    
    @inlinable
    func contains(item: IEntity) -> Bool {
        return self.items.contains(where: { $0 === item })
    }
    
    @inlinable
    func index(item: IEntity) -> Int? {
        return self.items.firstIndex(where: { $0 === item })
    }
    
    @inlinable
    @discardableResult
    func append(item: IEntity) -> Self {
        if self.contains(item: item) == false {
            self.items.append(item)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func remove(item: IEntity) -> Self {
        if let index = self.index(item: item) {
            self.items.remove(at: index)
        }
        return self
    }
    
}

public extension Field.Sequence {
    
    @inlinable
    @discardableResult
    func policy(_ value: Field.Policy) -> Self {
        self.policy = value
        return self
    }
    
    @inlinable
    @discardableResult
    func policy(_ value: () -> Field.Policy) -> Self {
        return self.policy(value())
    }

    @inlinable
    @discardableResult
    func policy(_ value: (Self) -> Field.Policy) -> Self {
        return self.policy(value(self))
    }
    
    @inlinable
    @discardableResult
    func items(_ value: [IEntity]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [IEntity]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [IEntity]) -> Self {
        return self.items(value(self))
    }
    
}

extension Field.Sequence : KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self.onChanged.emit()
    }
    
}

public extension Field {
    
    static func sequence(id: Id, policy: Field.Policy) -> Sequence {
        return .init(id: id, policy: policy)
    }
    
}
