//
//  KindKit
//

import KindCondition
import KindEvent
import KindMonadicMacro

@KindMonadic
public final class Condition : KindCondition.IEntity {
    
    public let observer = Observer< KindCondition.IObserver >()
    
    @KindMonadicProperty
    public var permission: IEntity {
        willSet {
            guard self.permission !== newValue else { return }
            self._unsubscribe()
        }
        didSet {
            guard self.permission !== oldValue else { return }
            self._subscribe()
            self._refresh()
        }
    }
    
    @KindMonadicProperty
    public var `in`: [Status] {
        didSet {
            guard self.in != oldValue else { return }
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
        _ permission: IEntity,
        in: [Status]
    ) {
        self.permission = permission
        self.in = `in`
        self._state = Self._get(permission, `in`)
        self._subscribe()
    }
    
    deinit {
        self._unsubscribe()
    }
    
    public func refresh() {
    }
    
    public func callAsFunction() -> Bool {
        return self._state
    }
    
}

private extension Condition {
    
    @inline(__always)
    func _subscribe() {
        self.permission.add(observer: self, priority: .internal)
    }
    
    @inline(__always)
    func _unsubscribe() {
        self.permission.remove(observer: self)
    }
    
    @inline(__always)
    func _refresh() {
        self._state = Self._get(self.permission, self.in)
    }
    
    @inline(__always)
    static func _get(_ permission: IEntity, _ in: [Status]) -> Bool {
        return `in`.contains(permission.status)
    }

}

extension Condition : IObserver {
    
    public func didRequest(_ permission: IEntity, source: Any?) {
        self._refresh()
    }
    
}
