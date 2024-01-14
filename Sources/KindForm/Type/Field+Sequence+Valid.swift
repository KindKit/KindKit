//
//  KindKit
//

import KindCondition
import KindEvent

extension Field.Sequence {
    
    final class Valid : KindCondition.IEntity {
        
        let observer = Observer< KindCondition.IObserver >()
        weak var mandatory: KindCondition.IEntity?
        weak var hidden: KindCondition.IEntity?
        weak var locked: KindCondition.IEntity?
        var policy: Field.Policy {
            didSet {
                guard self.policy != oldValue else { return }
                self._refresh()
            }
        }
        var items: [IEntity] = [] {
            willSet {
                for item in self.items {
                    item.valid.remove(observer: self)
                }
            }
            didSet {
                for item in self.items {
                    item.valid.add(observer: self, priority: .internal)
                }
                self._refresh()
            }
        }
        var state: Bool = true {
            didSet {
                guard self.state != oldValue else { return }
                self.notifyChanged()
            }
        }
        
        init(
            policy: Field.Policy,
            mandatory: KindCondition.IEntity,
            hidden: KindCondition.IEntity,
            locked: KindCondition.IEntity
        ) {
            self.policy = policy
            self.mandatory = mandatory
            self.hidden = hidden
            self.locked = locked
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        func refresh() {
            for item in self.items {
                item.valid.refresh()
            }
        }
        
        func callAsFunction() -> Bool {
            return self.state
        }
        
    }
    
}

private extension Field.Sequence.Valid {
    
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
        return self.policy.check(
            valid: self.items.kk_count(where: { $0.valid() }),
            count: self.items.kk_count(where: { $0.hidden() == false })
        )
    }

}

extension Field.Sequence.Valid : KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self._refresh()
    }
    
}
