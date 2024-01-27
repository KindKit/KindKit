//
//  KindKit
//

import Foundation
import KindCondition
import KindEvent
import KindMonadicMacro

public extension Field {
    
    @KindMonadic
    final class Static< Value : Equatable > : IField {
        
        public let id: Id
        
        public var parent: IEntity?
        
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
        
        public let valid: KindCondition.IEntity
        
        public var focusable: [IEntity] {
            guard self.hidden() == false || self.locked() == false else {
                return []
            }
            if self.onFocus.isEmpty == false {
                return [ self ]
            }
            return []
        }
        
        public var result: [IResult] {
            guard self.valid() == true else {
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
        public var value: Value {
            didSet {
                guard self.value != oldValue else { return }
                self.recursiveEmitOnChange()
            }
        }
        
        private let _mandatory: KindCondition.Optional
        private let _hidden: KindCondition.Optional
        private let _locked: KindCondition.Optional
        
        public init(
            id: Id,
            value: Value
        ) {
            self.id = id
            self.value = value
            self._mandatory = .init(default: true)
            self._hidden = .init(default: false)
            self._locked = .init(default: false)
            self.valid = KindCondition.Const(true)
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
        
        public func focus(after: IEntity?) -> IEntity? {
            guard self.hidden() == false && self.locked() == false else {
                return nil
            }
            if self.valid() == true {
                return nil
            }
            return self
        }
        
    }
    
}

private extension Field.Static {
    
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

extension Field.Static : KindCondition.IObserver {
    
    public func changed(_ condition: KindCondition.IEntity) {
        self.onChanged.emit()
    }
    
}

public extension Field {
    
    static func `static`(id: Id, value: Bool) -> Static< Bool > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: Int) -> Static< Int > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: UInt) -> Static< UInt > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: Float) -> Static< Float > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: Double) -> Static< Double > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: Date) -> Static< Date > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: String) -> Static< String > {
        return .init(id: id, value: value)
    }
    
    static func `static`(id: Id, value: URL) -> Static< URL > {
        return .init(id: id, value: value)
    }
    
}
