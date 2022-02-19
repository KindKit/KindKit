//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct RawRepresentableJsonDecoder< Enum : RawRepresentable > : IJsonValueDecoder where Enum.RawValue : IJsonDecoderAlias, Enum.RawValue == Enum.RawValue.JsonDecoder.Value {
    
    public static func decode(_ value: IJsonValue) throws -> Enum {
        guard let rawValue = try? Enum.RawValue.JsonDecoder.decode(value) else { throw JsonError.cast }
        guard let decoded = Enum(rawValue: rawValue) else { throw JsonError.cast }
        return decoded
    }
    
}

public struct RawRepresentableJsonEncoder< Enum : RawRepresentable > : IJsonValueEncoder where Enum.RawValue : IJsonEncoderAlias, Enum.RawValue == Enum.RawValue.JsonEncoder.Value {
    
    public static func encode(_ value: Enum) throws -> IJsonValue {
        return try Enum.RawValue.JsonEncoder.encode(value.rawValue)
    }
    
}

extension IJsonDecoderAlias where Self : RawRepresentable, RawValue : IJsonDecoderAlias, RawValue == RawValue.JsonDecoder.Value {
    
    public typealias JsonDecoder = RawRepresentableJsonDecoder< Self >
    
}

extension IJsonEncoderAlias where Self : RawRepresentable, RawValue : IJsonEncoderAlias, RawValue == RawValue.JsonEncoder.Value {
    
    public typealias JsonEncoder = RawRepresentableJsonEncoder< Self >
    
}
