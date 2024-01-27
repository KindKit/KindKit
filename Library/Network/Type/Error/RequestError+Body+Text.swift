//
//  KindKit
//

import Foundation
import KindDebug

public extension RequestError.Body {
    
    enum Text : Swift.Error, Hashable, Equatable {
        
        case encoding(String, String.Encoding)
        
    }
    
}

extension RequestError.Body.Text : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Text", sequenceBuilder: {
            switch self {
            case .encoding(let string, let encoding):
                KeyValueInfo(
                    key: StringInfo("Origin"),
                    value: string
                )
                KeyValueInfo(
                    key: StringInfo("Encoding"),
                    value: encoding.description
                )
            }
        })
    }
    
}
