//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Method {
        
        case get
        case post
        case put
        case delete
        case custom(String)
        
    }
    
}

public extension Api.Request.Method {
    
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .custom(let custom): return custom
        }

    }
    
}
