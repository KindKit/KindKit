//
//  KindKitUndoRedo
//

import Foundation

public protocol IUndoRedoTransformContext : IUndoRedoContext {
    
    var old: IUndoRedoPermanentContext { get }
    var new: IUndoRedoPermanentContext { get }

    func old(_ key: String) -> Any?
    func new(_ key: String) -> Any?

    func cleanup()
    
}

public protocol IUndoRedoMutatingTransformContext : IUndoRedoTransformContext {
    
    mutating func set(_ key: String, new: Any?, old: Any?)
    
}

public extension IUndoRedoTransformContext {
    
    func old< Key: RawRepresentable, Value >(
        _ key: Key
    ) -> Value where Key.RawValue == String {
        return self.old(key.rawValue) as! Value
    }
    
    func new< Key: RawRepresentable, Value >(
        _ key: Key
    ) -> Value where Key.RawValue == String {
        return self.new(key.rawValue) as! Value
    }
    
}

public extension IUndoRedoMutatingTransformContext {
    
    mutating func set< Key: RawRepresentable, Value >(
        _ key: Key,
        new: Value,
        old: Value
    ) where Key.RawValue == String {
        self.set(key.rawValue, new: new, old: old)
    }
    
}
