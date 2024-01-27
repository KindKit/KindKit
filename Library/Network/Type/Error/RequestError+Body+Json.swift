//
//  KindKit
//

import KindJSON
import KindDebug

public extension RequestError.Body {
    
    enum Json : Swift.Error, Hashable, Equatable {
        
        case access(AccessError)
        case coding(CodingError)
        case save(SaveError)
        
    }
    
}
extension RequestError.Body.Json : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Json", sequenceBuilder: {
            switch self {
            case .access(let error): error.buildInfo()
            case .coding(let error): error.buildInfo()
            case .save(let error): error.buildInfo()
            }
        })
    }
    
}
