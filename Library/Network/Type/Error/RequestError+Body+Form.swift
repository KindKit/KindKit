//
//  KindKit
//

import Foundation
import KindDebug

public extension RequestError.Body {
    
    enum Form : Swift.Error, Hashable, Equatable {
        
        case key(String)
        case pair(String, String)
        
    }
    
}

extension RequestError.Body.Form : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Form", sequenceBuilder: {
            switch self {
            case .key(let param):
                KeyValueInfo(
                    key: StringInfo("Param"),
                    value: param
                )
            case .pair(let param, let value):
                KeyValueInfo(
                    key: StringInfo("Param"),
                    value: param
                )
                KeyValueInfo(
                    key: StringInfo("Value"),
                    value: value
                )
            }
        })
    }
    
}
