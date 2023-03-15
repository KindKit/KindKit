//
//  KindKit
//

import Foundation

extension Form.Field.Sequence {
    
    final class Valid : ICondition {
        
        let observer = Observer< IConditionObserver >()
        weak var mandatory: ICondition?
        weak var hidden: ICondition?
        weak var locked: ICondition?
        var policy: Form.Field.Policy {
            didSet {
                guard self.policy != oldValue else { return }
                self._refresh()
            }
        }
        var items: [IForm] = [] {
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
            policy: Form.Field.Policy,
            mandatory: ICondition,
            hidden: ICondition,
            locked: ICondition
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

private extension Form.Field.Sequence.Valid {
    
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

extension Form.Field.Sequence.Valid : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self._refresh()
    }
    
}
