//
//  KindKit
//

import Foundation

extension IDebug where Self : BinaryInteger {
    
    public func debugInfo() -> Debug.Info {
        return .string(.init(self))
    }
    
}

extension Int : IDebug {
}

extension Int8 : IDebug {
}

extension Int16 : IDebug {
}

extension Int32 : IDebug {
}

extension Int64 : IDebug {
}

extension UInt : IDebug {
}

extension UInt8 : IDebug {
}

extension UInt16 : IDebug {
}

extension UInt32 : IDebug {
}

extension UInt64 : IDebug {
}
