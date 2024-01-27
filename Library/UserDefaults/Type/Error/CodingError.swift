//
//  KindKit
//

import KindDebug

public struct CodingError : Swift.Error {
    
    public let key: String
    
    public init(by key: String) {
        self.key = key
    }
    
}

extension CodingError : Hashable {
}

extension CodingError : Equatable {
}

extension CodingError : Sendable {
}

extension CodingError : CustomStringConvertible {
}

extension CodingError : CustomDebugStringConvertible {
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
