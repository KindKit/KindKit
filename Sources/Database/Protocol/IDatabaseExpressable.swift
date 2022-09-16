//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseExpressable {
    
    var query: String { get }

}

// MARK: Bool

extension Bool : IDatabaseExpressable {
    
    public var query: String {
        if self == true {
            return "1"
        }
        return "0"
    }
    
}

// MARK: Integer

extension IDatabaseExpressable where Self : BinaryInteger {
    
    public var query: String {
        return "\(self)"
    }

}

extension Int : IDatabaseExpressable {}
extension Int8 : IDatabaseExpressable {}
extension Int16 : IDatabaseExpressable {}
extension Int32 : IDatabaseExpressable {}
extension Int64 : IDatabaseExpressable {}
extension UInt : IDatabaseExpressable {}
extension UInt8 : IDatabaseExpressable {}
extension UInt16 : IDatabaseExpressable {}
extension UInt32 : IDatabaseExpressable {}
extension UInt64 : IDatabaseExpressable {}

// MARK: Real

extension IDatabaseExpressable where Self : BinaryFloatingPoint {
    
    public var query: String {
        return "\(self)"
    }

}

extension Float : IDatabaseExpressable {}
extension Double : IDatabaseExpressable {}

// MARK: String

extension String : IDatabaseExpressable {
    
    public var query: String {
        return "'\(self.replacingOccurrences(of: "'", with: "''"))'"
    }

}

extension URL : IDatabaseExpressable {
    
    public var query: String {
        return self.absoluteString.query
    }

}

// MARK: Blob

extension IDatabaseExpressable where Self : DataProtocol {
    
    public var query: String {
        return "x'\(self.hexString)'"
    }

}


extension Data : IDatabaseExpressable {}

// MARK: Extented

extension Identifier : IDatabaseExpressable where Raw : IDatabaseExpressable {
    
    public var query: String {
        return self.raw.query
    }
    
}

extension Optional : IDatabaseExpressable where Wrapped : IDatabaseExpressable {
    
    public var query: String {
        switch self {
        case .some(let value): return value.query
        case .none: return "NULL"
        }
    }
    
}

extension IDatabaseExpressable where Self : RawRepresentable, RawValue : IDatabaseExpressable {
    
    public var query: String {
        return self.rawValue.query
    }
    
}
