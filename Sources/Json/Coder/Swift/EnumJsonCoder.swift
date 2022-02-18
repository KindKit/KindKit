//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct EnumJsonDecoder< Enum : IEnumDecodable > : IJsonValueDecoder where Enum.RawValue : IJsonDecoderAlias, Enum.RawValue == Enum.RawValue.JsonDecoder.Value {
    
    public static func decode(_ value: IJsonValue) throws -> Enum.RealValue {
        guard let rawValue = try? Enum.RawValue.JsonDecoder.decode(value) else { throw JsonError.cast }
        guard let decoded = Enum(rawValue: rawValue) else { throw JsonError.cast }
        return decoded.realValue
    }
    
}

public struct EnumJsonEncoder< Enum : IEnumEncodable > : IJsonValueEncoder where Enum.RawValue : IJsonEncoderAlias, Enum.RawValue == Enum.RawValue.JsonEncoder.Value {
    
    public static func encode(_ value: Enum.RealValue) throws -> IJsonValue {
        let encoded = Enum(realValue: value)
        return try Enum.RawValue.JsonEncoder.encode(encoded.rawValue)
    }
    
}
