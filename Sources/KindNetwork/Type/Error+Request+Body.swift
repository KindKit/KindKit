//
//  KindKit
//

import Foundation

public extension Error.Request {
    
    enum Body : Swift.Error, Hashable, Equatable {
        
        case unknown
        case file(Error.Request.Body.File)
        case form(Error.Request.Body.Form)
        case json(Error.Request.Body.Json)
        case text(Error.Request.Body.Text)
        
    }
    
}
