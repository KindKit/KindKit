//
//  KindKit
//

import KindEvent

public final class Optional : IEntity {
    
    public let observer = Observer< IObserver >()
    public var condition: IEntity? {
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
        condition: IEntity? = nil,
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

private extension Optional {
    
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
    static func _get(_ condition: IEntity?, _ `default`: Bool) -> Bool {
        return condition?() ?? `default`
    }

}

public extension Optional {
    
    @inlinable
    @discardableResult
    func condition(_ value: IEntity?) -> Self {
        self.condition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func condition(_ value: () -> IEntity?) -> Self {
        return self.condition(value())
    }

    @inlinable
    @discardableResult
    func condition(_ value: (Self) -> IEntity?) -> Self {
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

extension Optional : IObserver {
    
    public func changed(_ condition: IEntity) {
        self._refresh()
    }
    
}
