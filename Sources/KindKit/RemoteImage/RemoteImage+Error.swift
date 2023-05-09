//
//  KindKit
//

import Foundation

public extension RemoteImage {
    
    enum Error : Swift.Error {
        
        case request(Api.Error.Request)
        case network(Api.Error.Network)
        case parse(Api.Error.Parse)
        case unknown

    }
    
}

extension RemoteImage.Error : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "RemoteImage.Error", info: {
            switch self {
            case .request(let error): return .pair(string: "Request", cast: error)
            case .network(let error): return .pair(string: "Network", cast: error)
            case .parse(let error): return .pair(string: "Parse", cast: error)
            case .unknown: return .string("Unknown")
            }
        })
    }
    
}
