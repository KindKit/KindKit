//
//  KindKit
//

import KindJSON

public extension Error.Request.Body {
    
    enum Json : Swift.Error, Hashable, Equatable {
        
        case coding(KindJSON.Error.Coding)
        case save(KindJSON.Error.Save)
        
    }
    
}
