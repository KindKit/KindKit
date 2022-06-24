//
//  KindKitUndoRedo
//

import Foundation

public protocol IUndoRedoPermanentContext : IUndoRedoContext {
    
    func get(_ key: String) -> Any?
    
    func cleanup()
    
}

public protocol IUndoRedoMutatingPermanentContext : IUndoRedoPermanentContext {
    
    mutating func set(_ key: String, value: Any?)
    
}

public extension IUndoRedoPermanentContext {
    
    func get< Key: RawRepresentable, Value >(
        _ key: Key
    ) -> Value where Key.RawValue == String {
        return self.get(key.rawValue) as! Value
    }
    
}

public extension IUndoRedoMutatingPermanentContext {
    
    mutating func set< Key: RawRepresentable, Value >(
        _ key: Key,
        value: Value
    ) where Key.RawValue == String {
        self.set(key.rawValue, value: value)
    }
    
}
