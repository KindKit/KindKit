//
//  KindKit
//

extension DebugTrait where Self : BinaryInteger {
    
    public func buildInfo() -> Info {
        return StringInfo(self.description)
    }
    
}

extension Int : DebugTrait {
}

extension Int8 : DebugTrait {
}

extension Int16 : DebugTrait {
}

extension Int32 : DebugTrait {
}

extension Int64 : DebugTrait {
}

extension UInt : DebugTrait {
}

extension UInt8 : DebugTrait {
}

extension UInt16 : DebugTrait {
}

extension UInt32 : DebugTrait {
}

extension UInt64 : DebugTrait {
}
