//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension Json.Coder.RawRepresentable : IJsonValueDecoder where RawCoder : IJsonValueDecoder, Enum.RawValue == RawCoder.JsonDecoded {
    
    public typealias JsonDecoded = Enum
    
    public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
        let value = try RawCoder.decode(value, path: path)
        guard let value = Enum(rawValue: value) else {
            throw Json.Error.Coding.cast(path)
        }
        return value
    }

}

extension Json.Coder.RawRepresentable : IJsonValueEncoder where RawCoder : IJsonValueEncoder, Enum.RawValue == RawCoder.JsonEncoded {
    
    public typealias JsonEncoded = Enum
    
    public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
        return try RawCoder.encode(value.rawValue, path: path)
    }
    
}
