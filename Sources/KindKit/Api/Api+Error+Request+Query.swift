//
//  KindKit
//

import Foundation

public extension Api.Error.Request {
    
    enum Query : Swift.Error {
        
        case requireProviderUrl
        case decode(String)
        case encode(URLComponents)
        
    }
    
}
