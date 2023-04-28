//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct Enum< EnumCoder, RawCoder > {
    }
    
}

extension Json.Coder.Enum : IJsonValueDecoder where EnumCoder : IEnumDecodable, RawCoder : IJsonValueDecoder, EnumCoder.RawValue == RawCoder.JsonDecoded {
    
    public typealias JsonDecoded = EnumCoder.RealValue
    
    public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
        let rawValue = try RawCoder.decode(value, path: path)
        guard let decoded = EnumCoder(rawValue: rawValue) else {
            throw Json.Error.Coding.cast(path)
        }
        return decoded.realValue
    }

}

extension Json.Coder.Enum : IJsonValueEncoder where EnumCoder : IEnumEncodable, RawCoder : IJsonValueEncoder, EnumCoder.RawValue == RawCoder.JsonEncoded {
    
    public typealias JsonEncoded = EnumCoder.RealValue
    
    public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
        let encoded = EnumCoder(realValue: value)
        return try RawCoder.encode(encoded.rawValue, path: path)
    }
    
}

extension IJsonDecoderAlias where Self : IEnumDecodable, RawValue : IJsonDecoderAlias, RawValue == RawValue.JsonDecoder.JsonDecoded {
    
    public typealias JsonDecoder = Json.Coder.Enum< Self, Self.RawValue.JsonDecoder >
    
}

extension IJsonEncoderAlias where Self : IEnumEncodable, RawValue : IJsonEncoderAlias, RawValue == RawValue.JsonEncoder.JsonEncoded {
    
    public typealias JsonEncoder = Json.Coder.Enum< Self, Self.RawValue.JsonEncoder >
    
}
