//
//  KindKit
//

import Foundation

public extension Api.Error.Request.Body {
    
    enum Text : Swift.Error, Hashable, Equatable {
        
        case encoding(String, String.Encoding)
        
    }
    
}
