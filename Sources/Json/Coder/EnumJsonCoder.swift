//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct EnumJsonDecoder< EnumType : IEnumDecodable, DecoderType: IJsonValueDecoder > : IJsonValueDecoder where EnumType.RawValue == DecoderType.ValueType {
    
    public static func decode(_ value: IJsonValue) throws -> EnumType.RealValue {
        guard let rawValue = try? DecoderType.decode(value) else { throw JsonError.cast }
        guard let decoded = EnumType(rawValue: rawValue) else { throw JsonError.cast }
        return decoded.realValue
    }
    
}

public struct EnumJsonEncoder< EnumType : IEnumEncodable, EncoderType: IJsonValueEncoder > : IJsonValueEncoder where EnumType.RawValue == EncoderType.ValueType {
    
    public static func encode(_ value: EnumType.RealValue) throws -> IJsonValue {
        let encoded = EnumType(realValue: value)
        return try EncoderType.encode(encoded.rawValue)
    }
    
}
