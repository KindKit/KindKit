//
//  KindKit
//

import KindCondition
import KindEvent
import KindMonadicMacro

extension Field {
    
    @KindMonadic
    public final class Dynamic< Value : Equatable > : IField {
        
        public typealias ValidatorClosure = (Value) -> Bool
        
        public let id: Id
        
        public weak var parent: IEntity?
        
        public var mandatory: KindCondition.IEntity {
            set { self._mandatory.condition = newValue }
            get { return self._mandatory }
        }
        
        public var hidden: KindCondition.IEntity {
            set { self._hidden.condition = newValue }
            get { return self._hidden }
        }
        
        public var locked: KindCondition.IEntity {
            set { self._locked.condition = newValue }
            get { return self._locked }
        }
        
        public var valid: KindCondition.IEntity {
            return self._valid
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
            guard self.hidden() == false else {
                return []
            }
            return [
                Result.Value(id: self.id, value: self.value)
            ]
        }
        
        public var onShouldFocus = Signal< Bool?, Void >()
        
        public var onFocus = Signal< Void, Void >()
        
        public var onChanged = Signal< Void, Void >()
        
        @KindMonadicProperty
        public var validator: ValidatorClosure? {
            set { self._valid.validator = newValue }
            get { self._valid.validator }
        }
        
        @KindMonadicProperty
        public var value: Value {
            set {
                guard self._valid.value != newValue else { return }
                self._valid.value = newValue
                self.recursiveEmitOnChange()
            }
            get { self._valid.value }
        }
        
        private let _mandatory: KindCondition.Optional
        private let _hidden: KindCondition.Optional
        private let _locked: KindCondition.Optional
        private let _valid: Valid
        
        public init(
            id: Id,
            value: Value
        ) {
            self.id = id
            self._mandatory = .init(default: false)
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self._valid = .init(
                mandatory: self._mandatory,
                hidden: self._hidden,
                locked: self._locked,
                value: value
            )
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func find(by id: Id) -> IEntity? {
            if self.id == id {
                return self
            }
            return nil
        }
        
    }
    
}

private extension Field.Dynamic {
    
    func _setup() {
        self.mandatory.add(observer: self, priority: .internal)
        self.hidden.add(observer: self, priority: .internal)
        self.locked.add(observer: self, priority: .internal)
        self.valid.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.mandatory.remove(observer: self)
        self.hidden.remove(observer: self)
        self.locked.remove(observer: self)
        self.valid.remove(observer: self)
    }
    
}

extension Field.Dynamic : KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self.onChanged.emit()
    }
    
}

public extension Field {
    
    static func dynamic(id: Id, value: String) -> Dynamic< String > {
        return .init(id: id, value: value)
    }
    
}
