//
//  KindKit
//

import KindCondition
import KindEvent

public extension Condition {

    final class Selected : KindCondition.IEntity {
        
        public let observer = Observer< KindCondition.IObserver >()
        public var field: Field.Select {
            didSet {
                self.field.onChanged.add(self, { $0._refresh() })
                self._refresh()
            }
        }
        public var item: IEntity {
            didSet {
                self.item.onChanged.add(self, { $0._refresh() })
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
            field: Field.Select,
            item: IEntity
        ) {
            self.field = field
            self.item = item
            self._state = Self._get(field, item)
            self._setup()
        }
        
        public func refresh() {
        }
        
        public func callAsFunction() -> Bool {
            return self._state
        }
        
    }
    
}

private extension Condition.Selected {
    
    @inline(__always)
    func _setup() {
        self.field.onChanged.add(self, { $0._refresh() })
        self.item.onChanged.add(self, { $0._refresh() })
    }
    
    @inline(__always)
    func _refresh() {
        self._state = Self._get(self.field, self.item)
    }
    
    @inline(__always)
    static func _get(_ field: Field.Select, _ item: IEntity) -> Bool {
        return field.contains(value: item)
    }

}

public extension Condition.Selected {
    
    @inlinable
    @discardableResult
    func field(_ value: Field.Select) -> Self {
        self.field = value
        return self
    }
    
    @inlinable
    @discardableResult
    func field(_ value: () -> Field.Select) -> Self {
        return self.field(value())
    }

    @inlinable
    @discardableResult
    func field(_ value: (Self) -> Field.Select) -> Self {
        return self.field(value(self))
    }
    
    @inlinable
    @discardableResult
    func item(_ value: IEntity) -> Self {
        self.item = value
        return self
    }
    
    @inlinable
    @discardableResult
    func item(_ value: () -> IEntity) -> Self {
        return self.item(value())
    }

    @inlinable
    @discardableResult
    func item(_ value: (Self) -> IEntity) -> Self {
        return self.item(value(self))
    }
    
}
