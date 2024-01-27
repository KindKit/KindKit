//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@KindMonadic
public final class Or : IEntity {
    
    public let observer = Observer< IObserver >()
    
    @KindMonadicProperty
    public var conditions: [IEntity] {
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
        _ conditions: [IEntity] = []
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

private extension Or {
    
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
    static func _get(_ conditions: [IEntity]) -> Bool {
        for condition in conditions {
            if condition() == true {
                return true
            }
        }
        return false
    }

}

extension Or : IObserver {
    
    public func changed(_ condition: IEntity) {
        self._refresh()
    }
    
}
