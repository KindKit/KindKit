//
//  KindKit
//

import Foundation

public extension Api.Error.Request.Body {
    
    enum Json : Swift.Error, Hashable, Equatable {
        
        case coding(KindKit.Json.Error.Coding)
        case save(KindKit.Json.Error.Save)
        
    }
    
}
