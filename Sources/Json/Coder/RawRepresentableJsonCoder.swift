//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct RawRepresentableJsonDecoder< Enum : RawRepresentable, Decoder : IJsonValueDecoder > : IJsonValueDecoder where Enum.RawValue == Decoder.Value {
    
    public static func decode(_ value: IJsonValue) throws -> Enum {
        guard let rawValue = try? Decoder.decode(value) else { throw JsonError.cast }
        guard let decoded = Enum(rawValue: rawValue) else { throw JsonError.cast }
        return decoded
    }
    
}

public struct RawRepresentableJsonEncoder< Enum : RawRepresentable, Encoder : IJsonValueEncoder > : IJsonValueEncoder where Enum.RawValue == Encoder.Value {
    
    public static func encode(_ value: Enum) throws -> IJsonValue {
        return try Encoder.encode(value.rawValue)
    }
    
}
