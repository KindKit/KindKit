//
//  KindKit
//

import Foundation

public extension Api.Error.Request.Body {
    
    enum Form : Swift.Error {
        
        case key(String)
        case pair(String, String)
        
    }
    
}
