//
//  KindKit
//

import KindDebug

public struct CodingError : Swift.Error {
    
    public let path: Path
    
    public init(in path: Path) {
        self.path = path
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
                key: StringInfo("Path"),
                value: self.path
            )
        })
    }
    
}
