//
//  KindKit
//

import KindDebug

public struct AccessError : Swift.Error, Hashable, Equatable {
    
    public let key: String
    
    public init(by key: String) {
        self.key = key
    }
    
}

extension AccessError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Access", info: self.key)
    }
    
}

extension AccessError : CustomStringConvertible {
}

extension AccessError : CustomDebugStringConvertible {
}
