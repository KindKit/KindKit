//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Integer< Value : BinaryInteger > : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = Value
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .init(value)
            case .real(let value):
                return .init(value)
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Database.Error.decode
                }
                return .init(number.intValue)
            case .blob:
                throw Database.Error.decode
            }
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            return .integer(Int(value))
        }
        
    }
    
}

extension IDatabaseValueAlias where Self : BinaryInteger {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Integer< Self >
    
}

extension Int : IDatabaseValueAlias {}
extension Int8 : IDatabaseValueAlias {}
extension Int16 : IDatabaseValueAlias {}
extension Int32 : IDatabaseValueAlias {}
extension Int64 : IDatabaseValueAlias {}
extension UInt : IDatabaseValueAlias {}
extension UInt8 : IDatabaseValueAlias {}
extension UInt16 : IDatabaseValueAlias {}
extension UInt32 : IDatabaseValueAlias {}
extension UInt64 : IDatabaseValueAlias {}
