//
//  KindKit
//

import Foundation

public extension Error.Request.Body {
    
    enum Text : Swift.Error, Hashable, Equatable {
        
        case encoding(String, String.Encoding)
        
    }
    
}
