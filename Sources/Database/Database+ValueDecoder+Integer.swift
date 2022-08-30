//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct Integer< Value : BinaryInteger > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Value {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return Value(value)
            case .real(let value):
                return Value(value)
            case .text(let value):
                guard let number = NSNumber.number(from: value) else {
                    throw Database.Error.decode
                }
                return Value(number.intValue)
            case .blob:
                throw Database.Error.decode
            }
        }
        
    }
    
}

extension Int : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension Int8 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension Int16 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension Int32 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension Int64 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension UInt : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension UInt8 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension UInt16 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension UInt32 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}

extension UInt64 : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Integer< Self >
    
}