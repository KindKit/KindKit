//
//  KindKit
//

import KindDebug

public struct CodingError : Swift.Error, Hashable, Equatable {
    
    public let key: String
    
    public init(in key: String) {
        self.key = key
    }
    
}

extension CodingError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Coding", sequenceBuilder: {
            KeyValueInfo(
                key: StringInfo("Key"),
                value: self.key
            )
        })
    }
    
}

extension CodingError : CustomStringConvertible {
}

extension CodingError : CustomDebugStringConvertible {
}
