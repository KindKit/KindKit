//
//  KindKit
//

import Foundation

public extension Form.Virtual {
    
    final class Item : IForm {
        
        public let id: Form.Id
        public weak var parent: IForm?
        public var hidden: ICondition {
            set { self._hidden.condition = newValue }
            get { return self._hidden }
        }
        public var locked: ICondition {
            set { self._locked.condition = newValue }
            get { return self._locked }
        }
        public var valid: ICondition {
            set { self._valid.condition = newValue }
            get { return self._valid }
        }
        public var focusable: [IForm] {
            guard self.hidden() == false || self.locked() == false else {
                return []
            }
            if self.shouldFocus == true {
                return [ self ]
            }
            return []
        }
        public var result: [IFormResult] {
            return []
        }
        public var onShouldFocus = Signal.Empty< Bool? >()
        public var onFocus = Signal.Empty< Void >()
        public var onChanged = Signal.Empty< Void >()
        
        private let _hidden: Condition.Optional
        private let _locked: Condition.Optional
        private let _valid: Condition.Optional
        
        public init() {
            self.id = .init()
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self._valid = .init(default: true)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func find(by id: Form.Id) -> IForm? {
            if self.id == id {
                return self
            }
            return self
        }
        
    }
    
}

private extension Form.Virtual.Item {
    
    func _setup() {
        self.hidden.add(observer: self, priority: .internal)
        self.locked.add(observer: self, priority: .internal)
        self.valid.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.hidden.remove(observer: self)
        self.locked.remove(observer: self)
        self.valid.remove(observer: self)
    }
    
}

extension Form.Virtual.Item: IConditionObserver {
    
    public func changed(_ condition: ICondition) {
        self.onChanged.emit()
    }
    
}

public extension IForm where Self == Form.Virtual.Item {
    
    static func item() -> Self {
        return .init()
    }
    
}
