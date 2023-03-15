//
//  KindKit
//

import Foundation

public extension Condition {

    final class Or : ICondition {
        
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
        
        private var _state: Bool {
            didSet {
                guard self._state != oldValue else { return }
                self.notifyChanged()
            }
        }

        public init(
            _ conditions: [ICondition] = []
        ) {
            self.conditions = conditions
            self._state = Self._get(conditions)
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

private extension Condition.Or {
    
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
        self._state = Self._get(self.conditions)
    }
    
    @inline(__always)
    static func _get(_ conditions: [ICondition]) -> Bool {
        for condition in conditions {
            if condition() == true {
                return true
            }
        }
        return false
    }

}

public extension Condition.Or {
    
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
    
}

extension Condition.Or : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self._refresh()
    }
    
}

public extension ICondition where Self == Condition.Or {
    
    @inlinable
    static func or(_ conditions: [ICondition]) -> Self {
        return .init(conditions)
    }
    
}
