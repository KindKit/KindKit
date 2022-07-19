//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public struct RawRepresentableUserDefaultsDecoder< Enum : RawRepresentable, Decoder : IUserDefaultsValueDecoder > : IUserDefaultsValueDecoder where Enum.RawValue == Decoder.Value {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Enum {
        guard let rawValue = try? Decoder.decode(value) else { throw Error.cast }
        guard let decoded = Enum(rawValue: rawValue) else { throw Error.cast }
        return decoded
    }
    
}

public struct RawRepresentableUserDefaultsEncoder< Enum : RawRepresentable, Encoder : IUserDefaultsValueEncoder > : IUserDefaultsValueEncoder where Enum.RawValue == Encoder.Value {
    
    public static func encode(_ value: Enum) throws -> IUserDefaultsValue {
        return try Encoder.encode(value.rawValue)
    }
    
}
