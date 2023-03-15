//
//  KindKit
//

import Foundation

public extension Form.Virtual {
    
    final class Group : IForm {
        
        public let id: Form.Id
        public weak var parent: IForm?
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
            for item in self.items {
                buffer.append(contentsOf: item.result)
            }
            guard buffer.isEmpty == false else {
                return []
            }
            return buffer
        }
        public var onShouldFocus = Signal.Empty< Bool? >()
        public var onFocus = Signal.Empty< Void >()
        public var onChanged = Signal.Empty< Void >()
        public var items: [IForm] = [] {
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
        
        private let _hidden: Condition.Optional
        private let _locked: Condition.Optional
        private let _valid: Condition.Optional
        private let _items: Condition.And
        
        public init() {
            self.id = .init()
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self._items = .init(isEmpty: true)
            self._valid = .optional(
                condition: self._items,
                default: true
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

private extension Form.Virtual.Group {
    
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

public extension Form.Virtual.Group {
    
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

public extension Form.Virtual.Group {
    
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

extension Form.Virtual.Group : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self.onChanged.emit()
    }
    
}

public extension IForm where Self == Form.Virtual.Group {
    
    static func group() -> Self {
        return .init()
    }
    
}
