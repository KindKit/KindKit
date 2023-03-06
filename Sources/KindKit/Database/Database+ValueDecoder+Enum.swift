//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct Enum< Enum : IEnumDecodable, Decoder : IDatabaseValueDecoder > : IDatabaseValueDecoder where Enum.RawValue == Decoder.DatabaseDecoded {
        
        public typealias DatabaseDecoded = Enum.RealValue
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
            guard let rawValue = try? Decoder.decode(value) else {
                throw Database.Error.decode
            }
            guard let decoded = Enum(rawValue: rawValue) else {
                throw Database.Error.decode
            }
            return decoded.realValue
        }
        
    }
    
}

extension IDatabaseValueDecoderAlias where Self : IEnumDecodable, RawValue : IDatabaseValueDecoderAlias, RawValue == RawValue.DatabaseValueDecoder.DatabaseDecoded {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Enum< Self, Self.RawValue.DatabaseValueDecoder >
    
}
