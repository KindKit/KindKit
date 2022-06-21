//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct RawRepresentableJsonDecoder< EnumType : RawRepresentable, DecoderType: IJsonValueDecoder > : IJsonValueDecoder where EnumType.RawValue == DecoderType.ValueType {
    
    public static func decode(_ value: IJsonValue) throws -> EnumType {
        guard let rawValue = try? DecoderType.decode(value) else { throw JsonError.cast }
        guard let decoded = EnumType(rawValue: rawValue) else { throw JsonError.cast }
        return decoded
    }
    
}

public struct RawRepresentableJsonEncoder< EnumType : RawRepresentable, EncoderType: IJsonValueEncoder > : IJsonValueEncoder where EnumType.RawValue == EncoderType.ValueType {
    
    public static func encode(_ value: EnumType) throws -> IJsonValue {
        return try EncoderType.encode(value.rawValue)
    }
    
}
