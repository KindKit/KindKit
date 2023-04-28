//
//  KindKit
//

import Foundation

public extension Api.Error.Request.Body {
    
    enum Json : Swift.Error {
        
        case coding(KindKit.Json.Error.Coding)
        case save(KindKit.Json.Error.Save)
        
    }
    
}
