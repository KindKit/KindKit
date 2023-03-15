//
//  KindKit
//

import Foundation

extension Form.Field.Dynamic {
    
    final class Valid : ICondition {
        
        let observer = Observer< IConditionObserver >()
        weak var mandatory: ICondition?
        weak var hidden: ICondition?
        weak var locked: ICondition?
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
            mandatory: ICondition,
            hidden: ICondition,
            locked: ICondition,
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

private extension Form.Field.Dynamic.Valid {
    
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

extension Form.Field.Dynamic.Valid : IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self._refresh()
    }
    
}
