//
//  KindKit
//

import Foundation

public extension Api.Error.Request.Body {
    
    enum File : Swift.Error {
        
        case notFound(URL)
        case other(URL)
        
    }
    
}
