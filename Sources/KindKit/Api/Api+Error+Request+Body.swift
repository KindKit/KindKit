//
//  KindKit
//

import Foundation

public extension Api.Error.Request {
    
    enum Body : Swift.Error {
        
        case unknown
        case file(Api.Error.Request.Body.File)
        case form(Api.Error.Request.Body.Form)
        case json(Api.Error.Request.Body.Json)
        case text(Api.Error.Request.Body.Text)
        
    }
    
}
