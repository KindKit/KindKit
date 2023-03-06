//
//  KindKit
//

import Foundation

public protocol IIdentifierKind {
}

public struct Identifier< Raw, Kind : IIdentifierKind > {
    
    public let raw: Raw
    
    public init(_ raw: Raw) {
        self.raw = raw
    }

}

extension Identifier where Raw == String {
    
    public init() {
        self.init(UUID().uuidString)
    }
    
}

extension Identifier : ExpressibleByIntegerLiteral where Raw == Int {
    
    public init(integerLiteral value: Raw) {
        self.init(value)
    }
    
}

extension Identifier : ExpressibleByStringLiteral where Raw == String {
    
    public typealias ExtendedGraphemeClusterLiteralType = Raw
    public typealias UnicodeScalarLiteralType = Raw

    public init(stringLiteral value: Raw) {
        self.init(value)
    }
    
}

extension Identifier : ExpressibleByExtendedGraphemeClusterLiteral where Raw == String {
}

extension Identifier : ExpressibleByUnicodeScalarLiteral where Raw == String {
}

extension Identifier : Equatable where Raw : Equatable {
}

extension Identifier : Hashable where Raw : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Kind.self))
        hasher.combine(self.raw)
    }
    
}

extension Identifier : Codable where Raw : Codable {
}
