//
//  KindKit
//

import Foundation

public extension Api.Request {
    
    enum Value : Hashable {
        
        case raw(String)
        case string(String)
        
    }
    
}

public extension Api.Request.Value {
    
    var string: String {
        switch self {
        case .raw(let string): return string
        case .string(let string): return string
        }
    }
    
    var encoded: String {
        get throws {
            switch self {
            case .raw(let string):
                return string
            case .string(let string):
                guard let string = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                    throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown)
                }
                return string
            }
        }
    }
    
}

extension Api.Request.Value : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = .raw(value)
    }
    
}
