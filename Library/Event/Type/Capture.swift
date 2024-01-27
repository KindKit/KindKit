//
//  KindKit
//

import KindCore

public enum Capture< Target : AnyObject, Result > {
    
    case strong(HeapObject< Target >)
    case weak(WeakObject< Target >, default: Result)
    
}

public extension Capture {
    
    static func strong(_ target: Target) -> Self {
        return .strong(.init(content: target))
    }
    
    static func weak(_ target: Target, `default`: Result) -> Self {
        return .weak(.init(content: target), default: `default`)
    }
    
    static func weak(_ target: Target) -> Self where Result == Void {
        return .weak(.init(content: target), default: ())
    }
    
    static func weak< Wrapped >(_ target: Target) -> Self where Result == Optional< Wrapped > {
        return .weak(.init(content: target), default: .none)
    }
    
}

public extension Capture {
    
    var target: Target? {
        switch self {
        case .strong(let store): return store.content
        case .weak(let store, _): return store.content
        }
    }
    
    func contains(_ target: AnyObject) -> Bool {
        return self.target === target
    }
    
}
