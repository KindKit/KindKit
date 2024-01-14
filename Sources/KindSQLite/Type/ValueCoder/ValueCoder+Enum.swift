//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Enum< Enum : IEnumCodable, Decoder : IValueCoder > : IValueCoder where Enum.RawValue == Decoder.SQLiteCoded {
        
        public typealias SQLiteDecoded = Enum.RealValue
        
        public static func decode(_ value: Value) throws -> SQLiteDecoded {
            let rawValue = try Decoder.decode(value)
            guard let decoded = Enum(rawValue: rawValue) else {
                throw Error.decode
            }
            return decoded.realValue
        }
        
        public static func encode(_ value: SQLiteDecoded) throws -> Value {
            let value = Enum(realValue: value)
            return try Decoder.encode(value.rawValue)
        }
        
    }
    
}

extension IValueAlias where Self : IEnumCodable, RawValue : IValueAlias, RawValue == RawValue.SQLiteValueCoder.SQLiteCoded {
    
    public typealias SQLiteValueCoder = ValueCoder.Enum< Self, Self.RawValue.SQLiteValueCoder >
    
}
