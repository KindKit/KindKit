//
//  KindKit
//

import Foundation

public extension Condition {

    final class Permission : ICondition {
        
        public let observer = Observer< IConditionObserver >()
        public var permission: IPermission {
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
        public var `in`: [KindKit.Permission.Status] {
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
            _ permission: IPermission,
            in: [KindKit.Permission.Status]
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
    
}

private extension Condition.Permission {
    
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
    static func _get(_ permission: IPermission, _ in: [KindKit.Permission.Status]) -> Bool {
        return `in`.contains(permission.status)
    }

}

public extension Condition.Permission {
    
    @inlinable
    @discardableResult
    func permission(_ value: IPermission) -> Self {
        self.permission = value
        return self
    }
    
    @inlinable
    @discardableResult
    func permission(_ value: () -> IPermission) -> Self {
        return self.permission(value())
    }

    @inlinable
    @discardableResult
    func permission(_ value: (Self) -> IPermission) -> Self {
        return self.permission(value(self))
    }
    
    @inlinable
    @discardableResult
    func `in`(_ value: [KindKit.Permission.Status]) -> Self {
        self.in = value
        return self
    }
    
    @inlinable
    @discardableResult
    func `in`(_ value: () -> [KindKit.Permission.Status]) -> Self {
        return self.in(value())
    }

    @inlinable
    @discardableResult
    func `in`(_ value: (Self) -> [KindKit.Permission.Status]) -> Self {
        return self.in(value(self))
    }
    
}

extension Condition.Permission : IPermissionObserver {
    
    public func didRequest(_ permission: IPermission, source: Any?) {
        self._refresh()
    }
    
}

public extension ICondition where Self == Condition.Permission {
    
    @inlinable
    static func permission(
        _ permission: IPermission,
        in: [Permission.Status]
    ) -> Self {
        return .init(permission, in: `in`)
    }
    
}
