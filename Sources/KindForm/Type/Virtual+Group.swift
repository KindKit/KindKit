//
//  KindKit
//

import KindCondition
import KindEvent

public extension Virtual {
    
    final class Group : IEntity {
        
        public let id: Id
        public weak var parent: IEntity?
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
            for item in self.items {
                buffer.append(contentsOf: item.result)
            }
            guard buffer.isEmpty == false else {
                return []
            }
            return buffer
        }
        public var onShouldFocus = Signal< Bool?, Void >()
        public var onFocus = Signal< Void, Void >()
        public var onChanged = Signal< Void, Void >()
        public var items: [IEntity] = [] {
            willSet {
                for item in self.items {
                    item.parent = nil
                }
            }
            didSet {
                for item in self.items {
                    item.parent = self
                }
                self._items.conditions = self.items.map({ $0.valid })
                self._valid.default = self.items.isEmpty
                self.onChanged.emit()
            }
        }
        
        private let _hidden: KindCondition.Optional
        private let _locked: KindCondition.Optional
        private let _valid: KindCondition.Optional
        private let _items: KindCondition.And
        
        public init() {
            self.id = .init()
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self._items = .init(isEmpty: true)
            self._valid = KindCondition.Optional(
                condition: self._items,
                default: true
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

private extension Virtual.Group {
    
    func _setup() {
        self.hidden.add(observer: self, priority: .internal)
        self.locked.add(observer: self, priority: .internal)
        self.valid.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.hidden.remove(observer: self)
        self.locked.remove(observer: self)
        self.valid.remove(observer: self)
    }
    
}

public extension Virtual.Group {
    
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

public extension Virtual.Group {
    
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

extension Virtual.Group : KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self.onChanged.emit()
    }
    
}

public extension Virtual {
    
    static func group() -> Virtual.Group {
        return .init()
    }
    
}
