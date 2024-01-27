//
//  KindKit
//

import Foundation
import KindDebug

public extension RequestError.Body {
    
    enum File : Swift.Error, Hashable, Equatable {
        
        case notFound(URL)
        case other(URL)
        
    }
    
}

extension RequestError.Body.File : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "File", sequenceBuilder: {
            switch self {
            case .notFound(let url):
                KeyValueInfo(
                    key: StringInfo("NotFound"),
                    value: url
                )
            case .other(let url):
                KeyValueInfo(
                    key: StringInfo("Other"),
                    value: url
                )
            }
        })
    }
    
}
