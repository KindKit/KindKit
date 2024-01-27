//
//  KindKit
//

import KindCondition
import KindEvent

public extension Virtual {
    
    final class Item : IEntity {
        
        public let id: Id
        
        public weak var parent: IEntity?
        
        public var hidden: KindCondition.IEntity {
            set { self._hidden.condition = newValue }
            get { return self._hidden }
        }
        
        public var locked: KindCondition.IEntity {
            set { self._locked.condition = newValue }
            get { return self._locked }
        }
        
        public var valid: KindCondition.IEntity {
            set { self._valid.condition = newValue }
            get { return self._valid }
        }
        
        public var focusable: [IEntity] {
            guard self.hidden() == false || self.locked() == false else {
                return []
            }
            if self.shouldFocus == true {
                return [ self ]
            }
            return []
        }
        
        public var result: [IResult] {
            return []
        }
        
        public var onShouldFocus = Signal< Bool?, Void >()
        public var onFocus = Signal< Void, Void >()
        public var onChanged = Signal< Void, Void >()
        
        private let _hidden: KindCondition.Optional
        private let _locked: KindCondition.Optional
        private let _valid: KindCondition.Optional
        
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
        
        public func find(by id: Id) -> IEntity? {
            if self.id == id {
                return self
            }
            return self
        }
        
    }
    
}

private extension Virtual.Item {
    
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

extension Virtual.Item: KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self.onChanged.emit()
    }
    
}

public extension Virtual {
    
    static func item() -> Virtual.Item {
        return .init()
    }
    
}
