//
//  KindKit
//

import Foundation

public extension Condition {

    final class Not : ICondition {
        
        public let observer = Observer< IConditionObserver >()
        public var condition: ICondition {
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
            _ condition: ICondition
        ) {
            self.condition = condition
            self._state = Self._get(condition)
            self._subscribe()
        }
        
        deinit {
            self._unsubscribe()
        }
        
        public func refresh() {
            self.condition.refresh()
        }
        
        public func callAsFunction() -> Bool {
            return self._state
        }
        
    }
    
}

private extension Condition.Not {
    
    @inline(__always)
    func _subscribe() {
        self.condition.add(observer: self, priority: .internal)
    }
    
    @inline(__always)
    func _unsubscribe() {
        self.condition.remove(observer: self)
    }
    
    @inline(__always)
    func _refresh() {
        self._state = Self._get(self.condition)
    }
    
    @inline(__always)
    static func _get(_ condition: ICondition) -> Bool {
        return !condition()
    }

}

public extension Condition.Not {
    
    @inlinable
    @discardableResult
    func condition(_ value: ICondition) -> Self {
        self.condition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func condition(_ value: () -> ICondition) -> Self {
        return self.condition(value())
    }

    @inlinable
    @discardableResult
    func condition(_ value: (Self) -> ICondition) -> Self {
        return self.condition(value(self))
    }
    
}

extension Condition.Not : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self._refresh()
    }
    
}

public extension ICondition where Self == Condition.Not {
    
    @inlinable
    static func not(_ condition: ICondition) -> Self {
        return .init(condition)
    }
    
}
