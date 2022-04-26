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
    
    func old< KeyType: RawRepresentable, ValueType >(
        _ key: KeyType
    ) -> ValueType where KeyType.RawValue == String {
        return self.old(key.rawValue) as! ValueType
    }
    
    func new< KeyType: RawRepresentable, ValueType >(
        _ key: KeyType
    ) -> ValueType where KeyType.RawValue == String {
        return self.new(key.rawValue) as! ValueType
    }
    
}

public extension IUndoRedoMutatingTransformContext {
    
    mutating func set< KeyType: RawRepresentable, ValueType >(
        _ key: KeyType,
        new: ValueType,
        old: ValueType
    ) where KeyType.RawValue == String {
        self.set(key.rawValue, new: new, old: old)
    }
    
}
