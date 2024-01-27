//
//  KindKit
//

import KindDebug
import KindNetwork

public enum Error : Swift.Error, Hashable, Equatable {
    
    case request(KindNetwork.RequestError)
    case network(KindNetwork.NetworkError)
    case parse(KindNetwork.ParseError)
    case unknown

}

extension Error : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Error", sequenceBuilder: {
            switch self {
            case .request(let error): KeyValueInfo(key: "Request", value: error)
            case .network(let error): KeyValueInfo(key: "Network", value: error)
            case .parse(let error): KeyValueInfo(key: "Parse", value: error)
            case .unknown: StringInfo("Unknown")
            }
        })
    }
    
}
