//
//  KindKit
//

import Foundation

public extension Condition {

    final class Optional : ICondition {
        
        public let observer = Observer< IConditionObserver >()
        public var condition: ICondition? {
            willSet {
                self._unsubscribe()
            }
            didSet {
                self._subscribe()
                self._refresh()
            }
        }
        public var `default`: Bool {
            didSet {
                guard self.default != oldValue else { return }
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
            condition: ICondition? = nil,
            `default`: Bool
        ) {
            self.condition = condition
            self.default = `default`
            self._state = Self._get(condition, `default`)
            self._subscribe()
        }
        
        deinit {
            self._unsubscribe()
        }
        
        public func refresh() {
            self.condition?.refresh()
        }
        
        public func callAsFunction() -> Bool {
            return self._state
        }
        
    }
    
}

private extension Condition.Optional {
    
    @inline(__always)
    func _subscribe() {
        guard let condition = self.condition else { return }
        condition.add(observer: self, priority: .internal)
    }
    
    @inline(__always)
    func _unsubscribe() {
        guard let condition = self.condition else { return }
        condition.remove(observer: self)
    }
    
    @inline(__always)
    func _refresh() {
        self._state = Self._get(self.condition, self.default)
    }
    
    @inline(__always)
    static func _get(_ condition: ICondition?, _ `default`: Bool) -> Bool {
        return condition?() ?? `default`
    }

}

public extension Condition.Optional {
    
    @inlinable
    @discardableResult
    func condition(_ value: ICondition?) -> Self {
        self.condition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func condition(_ value: () -> ICondition?) -> Self {
        return self.condition(value())
    }

    @inlinable
    @discardableResult
    func condition(_ value: (Self) -> ICondition?) -> Self {
        return self.condition(value(self))
    }
    
    @inlinable
    @discardableResult
    func `default`(_ value: Bool) -> Self {
        self.default = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `default`(_ value: () -> Bool) -> Self {
        return self.default(value())
    }

    @inlinable
    @discardableResult
    func `default`(_ value: (Self) -> Bool) -> Self {
        return self.default(value(self))
    }
    
}

extension Condition.Optional : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self._refresh()
    }
    
}

public extension ICondition where Self == Condition.Optional {
    
    @inlinable
    static func optional(condition: ICondition? = nil, `default`: Bool) -> Self {
        return .init(condition: condition, default: `default`)
    }
    
}
