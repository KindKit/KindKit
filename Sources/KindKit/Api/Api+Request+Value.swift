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

extension Api.Request.Value : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = .raw(value)
    }
    
}

public extension Api.Request.Value {
    
    @inlinable
    var string: String {
        switch self {
        case .raw(let string): return string
        case .string(let string): return string
        }
    }
    
    @inlinable
    var encoded: String? {
        switch self {
        case .raw(let string):
            return string
        case .string(let string):
            guard let string = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
            return string
        }
    }
    
}
