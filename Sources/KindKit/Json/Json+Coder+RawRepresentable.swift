//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension Json.Coder.RawRepresentable : IJsonValueDecoder where RawCoder : IJsonValueDecoder, Enum.RawValue == RawCoder.JsonDecoded {
    
    public static func decode(_ value: IJsonValue) throws -> Enum {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Json.Error.cast
        }
        guard let decoded = Enum(rawValue: rawValue) else {
            throw Json.Error.cast
        }
        return decoded
    }

}

extension Json.Coder.RawRepresentable : IJsonValueEncoder where RawCoder : IJsonValueEncoder, Enum.RawValue == RawCoder.JsonEncoded {
    
    public static func encode(_ value: Enum) throws -> IJsonValue {
        return try RawCoder.encode(value.rawValue)
    }
    
}
