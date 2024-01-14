//
//  KindKit
//

import Foundation

public extension Error.Request.Body {
    
    enum Form : Swift.Error, Hashable, Equatable {
        
        case key(String)
        case pair(String, String)
        
    }
    
}
