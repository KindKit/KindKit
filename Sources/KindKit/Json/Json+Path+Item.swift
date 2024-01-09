//
//  KindKit
//

import Foundation

public extension Json.Path {

    enum Item : Hashable, Equatable {
        
        case key(String)
        case index(Int)
        
    }
        
}

extension Json.Path.Item : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: Swift.StringLiteralType) {
        self = .key(value)
    }
    
}

extension Json.Path.Item : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Swift.IntegerLiteralType) {
        self = .index(value)
    }
    
}
