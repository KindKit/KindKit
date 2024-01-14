//
//  KindKit
//

public extension Path {

    enum Item : Hashable, Equatable {
        
        case key(String)
        case index(Int)
        
    }
        
}

extension Path.Item : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: Swift.StringLiteralType) {
        self = .key(value)
    }
    
}

extension Path.Item : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Swift.IntegerLiteralType) {
        self = .index(value)
    }
    
}
