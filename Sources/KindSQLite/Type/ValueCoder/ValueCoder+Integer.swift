//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Integer< ValueType : BinaryInteger > : IValueCoder {
        
        public typealias SQLiteCoded = ValueType
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return .init(value)
            case .real(let value):
                return .init(value)
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Error.decode
                }
                return .init(number.intValue)
            case .blob:
                throw Error.decode
            }
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return .integer(Int(value))
        }
        
    }
    
}

extension IValueAlias where Self : BinaryInteger {
    
    public typealias SQLiteValueCoder = ValueCoder.Integer< Self >
    
}

extension Int : IValueAlias {}
extension Int8 : IValueAlias {}
extension Int16 : IValueAlias {}
extension Int32 : IValueAlias {}
extension Int64 : IValueAlias {}
extension UInt : IValueAlias {}
extension UInt8 : IValueAlias {}
extension UInt16 : IValueAlias {}
extension UInt32 : IValueAlias {}
extension UInt64 : IValueAlias {}
