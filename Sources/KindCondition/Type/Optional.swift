//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@KindMonadic
public final class Optional : IEntity {
    
    public let observer = Observer< IObserver >()
    
    @KindMonadicProperty
    public var condition: IEntity? {
        willSet {
            self._unsubscribe()
        }
        didSet {
            self._subscribe()
            self._refresh()
        }
    }
    
    @KindMonadicProperty
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

extension Optional : IObserver {
    
    public func changed(_ condition: IEntity) {
        self._refresh()
    }
    
}
