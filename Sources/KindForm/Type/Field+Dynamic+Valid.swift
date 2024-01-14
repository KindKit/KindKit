//
//  KindKit
//

import KindCondition
import KindEvent

extension Field.Dynamic {
    
    final class Valid : KindCondition.IEntity {
        
        let observer = Observer< KindCondition.IObserver >()
        weak var mandatory: KindCondition.IEntity?
        weak var hidden: KindCondition.IEntity?
        weak var locked: KindCondition.IEntity?
        var validator: ((Value) -> Bool)? {
            didSet { self._refresh() }
        }
        var value: Value {
            didSet { self._refresh() }
        }
        var state: Bool = true {
            didSet {
                guard self.state != oldValue else { return }
                self.notifyChanged()
            }
        }
        
        init(
            mandatory: KindCondition.IEntity,
            hidden: KindCondition.IEntity,
            locked: KindCondition.IEntity,
            value: Value
        ) {
            self.mandatory = mandatory
            self.hidden = hidden
            self.locked = locked
            self.value = value
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        func refresh() {
        }
        
        func callAsFunction() -> Bool {
            return self.state
        }
        
    }
    
}

private extension Field.Dynamic.Valid {
    
    func _setup() {
        self.mandatory?.add(observer: self, priority: .internal)
        self.hidden?.add(observer: self, priority: .internal)
        self.locked?.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.mandatory?.remove(observer: self)
        self.hidden?.remove(observer: self)
        self.locked?.remove(observer: self)
    }
    
    func _refresh() {
        self.state = self._get()
    }
    
    func _get() -> Bool {
        guard self.hidden?() == false else {
            return false
        }
        guard self.mandatory?() == true else {
            return true
        }
        return self.validator?(self.value) ?? true
    }

}

extension Field.Dynamic.Valid : KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self._refresh()
    }
    
}
