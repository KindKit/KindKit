//
//  KindKit
//

import KindDebug

public extension Error {

    enum Coding : Swift.Error, Hashable, Equatable {
        
        case access(Path)
        case cast(Path)
        
    }
        
}

extension Error.Coding : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .object(name: "Error.Coding", sequence: { items in
            switch self {
            case .access(let path): items.append(.pair(string: "Access", cast: path))
            case .cast(let path): items.append(.pair(string: "Cast", cast: path))
            }
        })
    }
    
}

extension Error.Coding : CustomStringConvertible {
}

extension Error.Coding : CustomDebugStringConvertible {
}
