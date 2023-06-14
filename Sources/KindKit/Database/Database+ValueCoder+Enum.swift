//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Enum< Enum : IEnumCodable, Decoder : IDatabaseValueCoder > : IDatabaseValueCoder where Enum.RawValue == Decoder.DatabaseCoded {
        
        public typealias DatabaseDecoded = Enum.RealValue
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
            let rawValue = try Decoder.decode(value)
            guard let decoded = Enum(rawValue: rawValue) else {
                throw Database.Error.decode
            }
            return decoded.realValue
        }
        
        public static func encode(_ value: DatabaseDecoded) throws -> Database.Value {
            let value = Enum(realValue: value)
            return try Decoder.encode(value.rawValue)
        }
        
    }
    
}

extension IDatabaseValueAlias where Self : IEnumCodable, RawValue : IDatabaseValueAlias, RawValue == RawValue.DatabaseValueCoder.DatabaseCoded {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Enum< Self, Self.RawValue.DatabaseValueCoder >
    
}
