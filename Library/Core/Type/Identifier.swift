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

extension Identifier : Identifiable where Raw : Hashable {
    
    public typealias ID = Raw
    
    @inlinable
    public var id: Raw {
        return self.raw
    }
    
}

extension Identifier : ExpressibleByIntegerLiteral where Raw : ExpressibleByIntegerLiteral {
    
    @inlinable
    public init(integerLiteral value: Raw.IntegerLiteralType) {
        self.init(.init(integerLiteral: value))
    }
    
}

extension Identifier : ExpressibleByStringLiteral where Raw : ExpressibleByStringLiteral {

    @inlinable
    public init(stringLiteral value: Raw.StringLiteralType) {
        self.init(.init(stringLiteral: value))
    }
    
}

extension Identifier : ExpressibleByExtendedGraphemeClusterLiteral where Raw : ExpressibleByExtendedGraphemeClusterLiteral {
    
    @inlinable
    public init(extendedGraphemeClusterLiteral value: Raw.ExtendedGraphemeClusterLiteralType) {
        self.init(.init(extendedGraphemeClusterLiteral: value))
    }
    
}

extension Identifier : ExpressibleByUnicodeScalarLiteral where Raw : ExpressibleByUnicodeScalarLiteral {
    
    @inlinable
    public init(unicodeScalarLiteral value: Raw.UnicodeScalarLiteralType) {
        self.init(.init(unicodeScalarLiteral: value))
    }
    
}

extension Identifier : Hashable where Raw : Hashable & Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Kind.self))
        hasher.combine(self.raw)
    }
    
}

extension Identifier : Equatable where Raw : Equatable {
}

extension Identifier : Comparable where Raw : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.raw < rhs.raw
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.raw > rhs.raw
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.raw <= rhs.raw
    }
    
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.raw >= rhs.raw
    }
    
}
