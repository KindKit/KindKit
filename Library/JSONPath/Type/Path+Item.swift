//
//  KindKit
//

public extension Path {

    enum Item {
        
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

extension Path.Item : Hashable {
}

extension Path.Item : Equatable {
}

extension Path.Item : Sendable {
}
