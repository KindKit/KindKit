//
//  KindKitUndoRedo
//

import Foundation

public protocol IUndoRedoPermanentContext : IUndoRedoContext {
    
    func get(_ key: String) -> Any?
    
    func cleanup()
    
}

public protocol IUndoRedoMutatingPermanentContext : IUndoRedoPermanentContext, IUndoRedoMutatingContext {
    
    mutating func set(_ key: String, value: Any?)
    
}

public extension IUndoRedoPermanentContext {
    
    func get< KeyType: RawRepresentable, ValueType >(
        _ key: KeyType
    ) -> ValueType where KeyType.RawValue == String {
        return self.get(key.rawValue) as! ValueType
    }
    
}

public extension IUndoRedoMutatingPermanentContext {
    
    mutating func set< KeyType: RawRepresentable, ValueType >(
        _ key: KeyType,
        value: ValueType
    ) where KeyType.RawValue == String {
        self.set(key.rawValue, value: value)
    }
    
}
