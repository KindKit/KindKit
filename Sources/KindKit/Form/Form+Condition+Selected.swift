//
//  KindKit
//

import Foundation

public extension Form.Condition {

    final class Selected : ICondition {
        
        public let observer = Observer< IConditionObserver >()
        public var field: Form.Field.Select {
            didSet {
                self.field.onChanged.subscribe(self, { $0._refresh() })
                self._refresh()
            }
        }
        public var item: IForm {
            didSet {
                self.item.onChanged.subscribe(self, { $0._refresh() })
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
            field: Form.Field.Select,
            item: IForm
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

private extension Form.Condition.Selected {
    
    @inline(__always)
    func _setup() {
        self.field.onChanged.subscribe(self, { $0._refresh() })
        self.item.onChanged.subscribe(self, { $0._refresh() })
    }
    
    @inline(__always)
    func _refresh() {
        self._state = Self._get(self.field, self.item)
    }
    
    @inline(__always)
    static func _get(_ field: Form.Field.Select, _ item: IForm) -> Bool {
        return field.contains(value: item)
    }

}

public extension Form.Condition.Selected {
    
    @inlinable
    @discardableResult
    func field(_ value: Form.Field.Select) -> Self {
        self.field = value
        return self
    }
    
    @inlinable
    @discardableResult
    func field(_ value: () -> Form.Field.Select) -> Self {
        return self.field(value())
    }

    @inlinable
    @discardableResult
    func field(_ value: (Self) -> Form.Field.Select) -> Self {
        return self.field(value(self))
    }
    
    @inlinable
    @discardableResult
    func item(_ value: IForm) -> Self {
        self.item = value
        return self
    }
    
    @inlinable
    @discardableResult
    func item(_ value: () -> IForm) -> Self {
        return self.item(value())
    }

    @inlinable
    @discardableResult
    func item(_ value: (Self) -> IForm) -> Self {
        return self.item(value(self))
    }
    
}

public extension ICondition where Self == Form.Condition.Selected {
    
    @inlinable
    static func selected(field: Form.Field.Select, item: IForm) -> Self {
        return .init(field: field, item: item)
    }
    
}
