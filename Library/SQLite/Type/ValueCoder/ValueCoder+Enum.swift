//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Enum< Enum : IEnumCodable, Decoder : IValueCoder > : IValueCoder where Enum.RawValue == Decoder.SQLiteCoded {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Enum.RealValue {
            let rawValue = try Decoder.decode(value)
            guard let decoded = Enum(rawValue: rawValue) else {
                throw Error.decode
            }
            return decoded.realValue
        }
        
        public static func encode(_ value: Enum.RealValue) throws -> KindSQLite.Value {
            let value = Enum(realValue: value)
            return try Decoder.encode(value.rawValue)
        }
        
    }
    
}

extension IValueAlias where Self : IEnumCodable, RawValue : IValueAlias, RawValue == RawValue.SQLiteValueCoder.SQLiteCoded {
    
    public typealias SQLiteValueCoder = ValueCoder.Enum< Self, Self.RawValue.SQLiteValueCoder >
    
}
