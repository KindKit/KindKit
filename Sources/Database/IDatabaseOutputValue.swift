//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseOutputValue {
    
    static func value(statement: Database.Statement, at index: Int) throws -> Self
    
}

extension Bool : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Bool {
        return statement.value(at: index)
    }
    
}

extension Int8 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Int8 {
        return Int8(statement.value(at: index) as Int64)
    }
    
}

extension UInt8 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> UInt8 {
        return UInt8(statement.value(at: index) as Int64)
    }
    
}

extension Int16 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Int16 {
        return Int16(statement.value(at: index) as Int64)
    }
    
}

extension UInt16 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> UInt16 {
        return UInt16(statement.value(at: index) as Int64)
    }
    
}

extension Int32 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Int32 {
        return Int32(statement.value(at: index) as Int64)
    }
    
}

extension UInt32 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> UInt32 {
        return UInt32(statement.value(at: index) as Int64)
    }
    
}

extension Int64 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Int64 {
        return statement.value(at: index)
    }
    
}

extension UInt64 : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> UInt64 {
        return UInt64(statement.value(at: index) as Int64)
    }
    
}

extension Int : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Int {
        return Int(statement.value(at: index) as Int64)
    }
    
}

extension UInt : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> UInt {
        return UInt(statement.value(at: index) as Int64)
    }
    
}

extension Float : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Float {
        return Float(statement.value(at: index) as Double)
    }
    
}

extension Double : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Double {
        return statement.value(at: index)
    }
    
}

extension Decimal : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Decimal {
        return statement.value(at: index)
    }
    
}

extension String : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> String {
        return statement.value(at: index)
    }
    
}

extension URL : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> URL {
        let string = statement.value(at: index) as String
        guard let url = URL(string: string) else {
            throw Database.Statement.Error.cast(index: index)
        }
        return url
    }
    
}

extension Date : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Date {
        return Date(timeIntervalSince1970: TimeInterval(statement.value(at: index) as Double))
    }
    
}

extension Data : IDatabaseOutputValue {
    
    public static func value(statement: Database.Statement, at index: Int) throws -> Data {
        return statement.value(at: index)
    }
    
}
