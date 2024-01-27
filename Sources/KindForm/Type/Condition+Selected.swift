//
//  KindKit
//

import KindCondition
import KindEvent
import KindMonadicMacro

extension Condition {

    @KindMonadic
    public final class Selected : KindCondition.IEntity {
        
        public let observer = Observer< KindCondition.IObserver >()
        
        @KindMonadicProperty
        public var field: Field.Select {
            didSet {
                self.field.onChanged.add(self, { $0._refresh() })
                self._refresh()
            }
        }
        
        @KindMonadicProperty
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
