//
//  KindKit
//

import Foundation
import KindDebug

public extension RequestError {
    
    enum Query : Swift.Error, Hashable, Equatable {
        
        case requireProviderUrl
        case decode(String)
        case encode(URLComponents)
        
    }
    
}

extension RequestError.Query : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Query", sequenceBuilder: {
            switch self {
            case .requireProviderUrl:
                StringInfo("RequireProviderUrl")
            case .decode(let components):
                KeyValueInfo(
                    key: StringInfo("Decode"),
                    value: components
                )
            case .encode(let components):
                KeyValueInfo(
                    key: StringInfo("Encode"),
                    value: components
                )
            }
        })
    }
    
}
