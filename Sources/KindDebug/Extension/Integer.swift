//
//  KindKit
//

extension IEntity where Self : BinaryInteger {
    
    public func debugInfo() -> Info {
        return .string(.init(self))
    }
    
}

extension Int : IEntity {
}

extension Int8 : IEntity {
}

extension Int16 : IEntity {
}

extension Int32 : IEntity {
}

extension Int64 : IEntity {
}

extension UInt : IEntity {
}

extension UInt8 : IEntity {
}

extension UInt16 : IEntity {
}

extension UInt32 : IEntity {
}

extension UInt64 : IEntity {
}
