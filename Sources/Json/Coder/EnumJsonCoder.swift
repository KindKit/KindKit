//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct EnumJsonDecoder< Enum : IEnumDecodable, Decoder : IJsonValueDecoder > : IJsonValueDecoder where Enum.RawValue == Decoder.Value {
    
    public static func decode(_ value: IJsonValue) throws -> Enum.RealValue {
        guard let rawValue = try? Decoder.decode(value) else { throw JsonError.cast }
        guard let decoded = Enum(rawValue: rawValue) else { throw JsonError.cast }
        return decoded.realValue
    }
    
}

extension IJsonDecoderAlias where Self : IEnumDecodable, RawValue : IJsonDecoderAlias, RawValue == RawValue.JsonDecoder.Value {
    
    public typealias JsonDecoder = EnumJsonDecoder< Self, Self.RawValue.JsonDecoder >
    
}

public struct EnumJsonEncoder< Enum : IEnumEncodable, Encoder : IJsonValueEncoder > : IJsonValueEncoder where Enum.RawValue == Encoder.Value {
    
    public static func encode(_ value: Enum.RealValue) throws -> IJsonValue {
        let encoded = Enum(realValue: value)
        return try Encoder.encode(encoded.rawValue)
    }
    
}

extension IJsonEncoderAlias where Self : IEnumEncodable, RawValue : IJsonEncoderAlias, RawValue == RawValue.JsonEncoder.Value {
    
    public typealias JsonEncoder = EnumJsonEncoder< Self, Self.RawValue.JsonEncoder >
    
}
