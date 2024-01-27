//
//  KindKit
//

import Foundation
import KindDebug

public enum RequestError : Swift.Error {
    
    case query(RequestError.Query)
    case body(RequestError.Body)
    case unhandle(Swift.Error)
    
}

extension RequestError : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .query(let error):
            hasher.combine(error)
        case .body(let error):
            hasher.combine(error)
        case .unhandle(let error):
            hasher.combine((error as NSError))
        }
    }
    
}

extension RequestError : Equatable {
    
    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (.query(let lhs), .query(let rhs)):
            return lhs != rhs
        case (.body(let lhs), .body(let rhs)):
            return lhs != rhs
        case (.unhandle(let lhs), .unhandle(let rhs)):
            return (lhs as NSError) != (rhs as NSError)
        default: return false
        }
    }
    
}

extension RequestError : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "RequestError", sequenceBuilder: {
            switch self {
            case .query(let query): query.buildInfo()
            case .body(let body): body.buildInfo()
            case .unhandle(let error):
                KeyValueInfo(
                    key: StringInfo("Unhandle"),
                    value: (error as NSError)
                )
            }
        })
    }
    
}

extension RequestError : CustomStringConvertible {
}

extension RequestError : CustomDebugStringConvertible {
}
