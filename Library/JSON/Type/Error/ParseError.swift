//
//  KindKit
//

import KindDebug

public enum ParseError : Swift.Error {
    
    case notJson
    
}

extension ParseError : Hashable {
}

extension ParseError : Equatable {
}

extension ParseError : Sendable {
}

extension ParseError : CustomStringConvertible {
}

extension ParseError : CustomDebugStringConvertible {
}

extension ParseError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Parse", sequenceBuilder: {
            switch self {
            case .notJson: StringInfo("NotJson")
            }
        })
    }
    
}
