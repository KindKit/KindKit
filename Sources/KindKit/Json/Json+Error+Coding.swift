//
//  KindKit
//

import Foundation

public extension Json.Error {

    enum Coding : Swift.Error, Hashable, Equatable {
        
        case access(Json.Path)
        case cast(Json.Path)
        
    }
        
}

extension Json.Error.Coding : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "Json.Error.Coding", sequence: { items in
            switch self {
            case .access(let path): items.append(.pair(string: "Access", cast: path))
            case .cast(let path): items.append(.pair(string: "Cast", cast: path))
            }
        })
    }
    
}

extension Json.Error.Coding : CustomStringConvertible {
}

extension Json.Error.Coding : CustomDebugStringConvertible {
}
