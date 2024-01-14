//
//  KindKit
//

public protocol ITransformContext : IContext {
    
    var old: IPermanentContext { get }
    var new: IPermanentContext { get }

    func old(_ key: String) -> Any?
    func new(_ key: String) -> Any?

    func cleanup()
    
}

public protocol IMutatingTransformContext : ITransformContext {
    
    mutating func set(_ key: String, new: Any?, old: Any?)
    
}

public extension ITransformContext {
    
    func old< Key : RawRepresentable, Value >(
        _ key: Key
    ) -> Value where Key.RawValue == String {
        return self.old(key.rawValue) as! Value
    }
    
    func new< Key : RawRepresentable, Value >(
        _ key: Key
    ) -> Value where Key.RawValue == String {
        return self.new(key.rawValue) as! Value
    }
    
}

public extension IMutatingTransformContext {
    
    mutating func set< Key : RawRepresentable, Value >(
        _ key: Key,
        new: Value,
        old: Value
    ) where Key.RawValue == String {
        self.set(key.rawValue, new: new, old: old)
    }
    
}
