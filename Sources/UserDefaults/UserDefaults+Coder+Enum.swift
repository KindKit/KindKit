//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {
    
    struct Enum< EnumCoder, RawCoder > {
    }
    
}

extension UserDefaults.Coder.Enum : IUserDefaultsValueDecoder where EnumCoder : IEnumDecodable, RawCoder : IUserDefaultsValueDecoder, EnumCoder.RawValue == RawCoder.UserDefaultsDecoded {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> EnumCoder.RealValue {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw UserDefaults.Error.cast
        }
        guard let decoded = EnumCoder(rawValue: rawValue) else {
            throw UserDefaults.Error.cast
        }
        return decoded.realValue
    }

}

extension UserDefaults.Coder.Enum : IUserDefaultsValueEncoder where EnumCoder : IEnumEncodable, RawCoder : IUserDefaultsValueEncoder, EnumCoder.RawValue == RawCoder.UserDefaultsEncoded {
    
    public static func encode(_ value: EnumCoder.RealValue) throws -> IUserDefaultsValue {
        let encoded = EnumCoder(realValue: value)
        return try RawCoder.encode(encoded.rawValue)
    }
    
}

extension IUserDefaultsDecoderAlias where Self : IEnumDecodable, RawValue : IUserDefaultsDecoderAlias, RawValue == RawValue.UserDefaultsDecoder.UserDefaultsDecoded {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Enum< Self, Self.RawValue.UserDefaultsDecoder >
    
}

extension IUserDefaultsEncoderAlias where Self : IEnumEncodable, RawValue : IUserDefaultsEncoderAlias, RawValue == RawValue.UserDefaultsEncoder.UserDefaultsEncoded {
    
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Enum< Self, Self.RawValue.UserDefaultsEncoder >
    
}
