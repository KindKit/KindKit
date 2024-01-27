//
//  KindKit
//

import Foundation

public extension Request {
    
    enum Method {
        
        case get
        case post
        case put
        case delete
        case custom(String)
        
    }
    
}

extension Request.Method : Hashable {
}

extension Request.Method : Equatable {
}

extension Request.Method : Sendable {
}

public extension Request.Method {
    
    @inlinable
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
