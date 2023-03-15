//
//  KindKit
//

import Foundation

public extension Condition {

    final class And : ICondition {
        
        public let observer = Observer< IConditionObserver >()
        public var conditions: [ICondition] {
            willSet {
                self._unsubscribe()
            }
            didSet {
                self._subscribe()
                self._refresh()
            }
        }
        public var isEmpty: Bool {
            didSet {
                guard self.isEmpty != oldValue else { return }
                self._refresh()
            }
        }
        
        private var _state: Bool {
            didSet {
                guard self._state != oldValue else { return }
                self.notifyChanged()
            }
        }

        public init(
            conditions: [ICondition] = [],
            isEmpty: Bool = false
        ) {
            self.conditions = conditions
            self.isEmpty = isEmpty
            self._state = Self._get(conditions, isEmpty)
            self._subscribe()
        }
        
        deinit {
            self._unsubscribe()
        }
        
        public func refresh() {
            for condition in self.conditions {
                condition.refresh()
            }
        }
        
        public func callAsFunction() -> Bool {
            return self._state
        }
        
    }
    
}

private extension Condition.And {
    
    @inline(__always)
    func _subscribe() {
        for condition in self.conditions {
            condition.add(observer: self, priority: .internal)
        }
    }
    
    @inline(__always)
    func _unsubscribe() {
        for condition in self.conditions {
            condition.remove(observer: self)
        }
    }
    
    @inline(__always)
    func _refresh() {
        self._state = Self._get(self.conditions, self.isEmpty)
    }
    
    @inline(__always)
    static func _get(_ conditions: [ICondition], _ isEmpty: Bool) -> Bool {
        guard conditions.isEmpty == false else {
            return isEmpty
        }
        for condition in conditions {
            if condition() == false {
                return false
            }
        }
        return true
    }

}

public extension Condition.And {
    
    @inlinable
    @discardableResult
    func conditions(_ value: [ICondition]) -> Self {
        self.conditions = value
        return self
    }
    
    @inlinable
    @discardableResult
    func conditions(_ value: () -> [ICondition]) -> Self {
        return self.conditions(value())
    }

    @inlinable
    @discardableResult
    func conditions(_ value: (Self) -> [ICondition]) -> Self {
        return self.conditions(value(self))
    }
    
    @inlinable
    @discardableResult
    func isEmpty(_ value: Bool) -> Self {
        self.isEmpty = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isEmpty(_ value: () -> Bool) -> Self {
        return self.isEmpty(value())
    }

    @inlinable
    @discardableResult
    func isEmpty(_ value: (Self) -> Bool) -> Self {
        return self.isEmpty(value(self))
    }
    
}

extension Condition.And : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self._refresh()
    }
    
}

public extension ICondition where Self == Condition.And {
    
    @inlinable
    static func and(
        conditions: [ICondition],
        isEmpty: Bool = false
    ) -> Self {
        return .init(conditions: conditions, isEmpty: isEmpty)
    }
    
}
