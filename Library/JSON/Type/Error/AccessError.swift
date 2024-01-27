//
//  KindKit
//

import KindDebug

public struct AccessError : Swift.Error {
    
    public let path: Path
    
    public init(in path: Path) {
        self.path = path
    }
    
}

extension AccessError : Hashable {
}

extension AccessError : Equatable {
}

extension AccessError : Sendable {
}

extension AccessError : CustomStringConvertible {
}

extension AccessError : CustomDebugStringConvertible {
}

extension AccessError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Access", info: self.path)
    }
    
}
