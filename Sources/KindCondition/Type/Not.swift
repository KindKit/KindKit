//
//  KindKit
//

import KindEvent

public final class Not : IEntity {
    
    public let observer = Observer< IObserver >()
    public var condition: IEntity {
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
        _ condition: IEntity
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

private extension Not {
    
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
    static func _get(_ condition: IEntity) -> Bool {
        return !condition()
    }

}

public extension Not {
    
    @inlinable
    @discardableResult
    func condition(_ value: IEntity) -> Self {
        self.condition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func condition(_ value: () -> IEntity) -> Self {
        return self.condition(value())
    }

    @inlinable
    @discardableResult
    func condition(_ value: (Self) -> IEntity) -> Self {
        return self.condition(value(self))
    }
    
}

extension Not : IObserver {
    
    public func changed(_ condition: IEntity) {
        self._refresh()
    }
    
}
