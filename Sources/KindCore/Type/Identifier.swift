//
//  KindKit
//

import Foundation

public protocol IIdentifierKind {
}

public struct Identifier< RawType : Hashable, KindType : IIdentifierKind > : Identifiable {
    
    public let id: RawType
    
    public init(_ id: RawType) {
        self.id = id
    }

}

extension Identifier where RawType == String {
    
    public init() {
        self.init(UUID().uuidString)
    }
    
}

extension Identifier : ExpressibleByIntegerLiteral where RawType == Int {
    
    public init(integerLiteral value: RawType) {
        self.init(value)
    }
    
}

extension Identifier : ExpressibleByStringLiteral where RawType == String {
    
    public typealias ExtendedGraphemeClusterLiteralType = RawType
    public typealias UnicodeScalarLiteralType = RawType

    public init(stringLiteral value: RawType) {
        self.init(value)
    }
    
}

extension Identifier : ExpressibleByExtendedGraphemeClusterLiteral where RawType == String {
}

extension Identifier : ExpressibleByUnicodeScalarLiteral where RawType == String {
}

extension Identifier : Equatable where RawType : Equatable {
}

extension Identifier : Hashable where RawType : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: KindType.self))
        hasher.combine(self.id)
    }
    
}

extension Identifier : Codable where RawType : Codable {
}
