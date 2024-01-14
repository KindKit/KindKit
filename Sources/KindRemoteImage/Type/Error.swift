//
//  KindKit
//

import KindDebug
import KindNetwork

public enum Error : Swift.Error, Hashable, Equatable {
    
    case request(KindNetwork.Error.Request)
    case network(KindNetwork.Error.Network)
    case parse(KindNetwork.Error.Parse)
    case unknown

}

extension Error : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .object(name: "Error", info: {
            switch self {
            case .request(let error): return .pair(string: "Request", cast: error)
            case .network(let error): return .pair(string: "Network", cast: error)
            case .parse(let error): return .pair(string: "Parse", cast: error)
            case .unknown: return .string("Unknown")
            }
        })
    }
    
}
