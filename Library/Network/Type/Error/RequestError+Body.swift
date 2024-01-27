//
//  KindKit
//

import Foundation
import KindDebug

public extension RequestError {
    
    enum Body : Swift.Error, Hashable, Equatable {
        
        case unknown
        case file(RequestError.Body.File)
        case form(RequestError.Body.Form)
        case json(RequestError.Body.Json)
        case text(RequestError.Body.Text)
        
    }
    
}

extension RequestError.Body : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "Body", sequenceBuilder: {
            switch self {
            case .unknown: StringInfo("Unknown")
            case .file(let file): file.buildInfo()
            case .form(let form): form.buildInfo()
            case .json(let json): json.buildInfo()
            case .text(let text): text.buildInfo()
            }
        })
    }
    
}
