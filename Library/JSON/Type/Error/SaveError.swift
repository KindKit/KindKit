//
//  KindKit
//

import KindDebug

public enum SaveError : Swift.Error {
    
    case empty
    case unknown
    
}

extension SaveError : Hashable {
}

extension SaveError : Equatable {
}

extension SaveError : Sendable {
}

extension SaveError : CustomStringConvertible {
}

extension SaveError : CustomDebugStringConvertible {
}

extension SaveError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Save", sequenceBuilder: {
            switch self {
            case .empty: StringInfo("Empty")
            case .unknown: StringInfo("Unknown")
            }
        })
    }
    
}
