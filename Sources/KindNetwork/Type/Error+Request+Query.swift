//
//  KindKit
//

import Foundation

public extension Error.Request {
    
    enum Query : Swift.Error, Hashable, Equatable {
        
        case requireProviderUrl
        case decode(String)
        case encode(URLComponents)
        
    }
    
}
