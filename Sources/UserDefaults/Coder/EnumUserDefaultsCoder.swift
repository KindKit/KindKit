//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public struct EnumUserDefaultsDecoder< Enum : IEnumDecodable, Decoder : IUserDefaultsValueDecoder > : IUserDefaultsValueDecoder where Enum.RawValue == Decoder.Value {
    
    public enum Error : Swift.Error {
        case cast
    }
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Enum.RealValue {
        guard let rawValue = try? Decoder.decode(value) else { throw Error.cast }
        guard let decoded = Enum(rawValue: rawValue) else { throw Error.cast }
        return decoded.realValue
    }
    
}

extension IUserDefaultsDecoderAlias where Self : IEnumDecodable, RawValue : IUserDefaultsDecoderAlias, RawValue == RawValue.UserDefaultsDecoder.Value {
    
    public typealias UserDefaultsDecoder = EnumUserDefaultsDecoder< Self, Self.RawValue.UserDefaultsDecoder >
    
}

public struct EnumUserDefaultsEncoder< Enum : IEnumEncodable, Encoder : IUserDefaultsValueEncoder > : IUserDefaultsValueEncoder where Enum.RawValue == Encoder.Value {
    
    public static func encode(_ value: Enum.RealValue) throws -> IUserDefaultsValue {
        let encoded = Enum(realValue: value)
        return try Encoder.encode(encoded.rawValue)
    }
    
}

extension IUserDefaultsEncoderAlias where Self : IEnumEncodable, RawValue : IUserDefaultsEncoderAlias, RawValue == RawValue.UserDefaultsEncoder.Value {
    
    public typealias UserDefaultsEncoder = EnumUserDefaultsEncoder< Self, Self.RawValue.UserDefaultsEncoder >
    
}
