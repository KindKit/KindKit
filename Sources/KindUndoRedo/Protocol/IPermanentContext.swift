//
//  KindKit
//

public protocol IPermanentContext : IContext {
    
    func get(_ key: String) -> Any?
    
    func cleanup()
    
}

public protocol IMutatingPermanentContext : IPermanentContext {
    
    mutating func set(_ key: String, value: Any?)
    
}

public extension IPermanentContext {
    
    func get< Key : RawRepresentable, Value >(
        _ key: Key
    ) -> Value where Key.RawValue == String {
        return self.get(key.rawValue) as! Value
    }
    
}

public extension IMutatingPermanentContext {
    
    mutating func set< Key : RawRepresentable, Value >(
        _ key: Key,
        value: Value
    ) where Key.RawValue == String {
        self.set(key.rawValue, value: value)
    }
    
}
