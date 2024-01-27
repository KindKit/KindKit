//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@KindMonadic
public final class Not : IEntity {
    
    public let observer = Observer< IObserver >()
    
    @KindMonadicProperty
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

extension Not : IObserver {
    
    public func changed(_ condition: IEntity) {
        self._refresh()
    }
    
}
