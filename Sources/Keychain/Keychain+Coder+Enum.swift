//
//  KindKit
//

import Foundation

public extension Keychain.Coder {
    
    struct Enum< EnumCoder, RawCoder > {
    }
    
}

extension Keychain.Coder.Enum : IKeychainValueDecoder where EnumCoder : IEnumDecodable, RawCoder : IKeychainValueDecoder, EnumCoder.RawValue == RawCoder.KeychainDecoded {
    
    public static func decode(_ value: Data) throws -> EnumCoder.RealValue {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Keychain.Error.cast
        }
        guard let decoded = EnumCoder(rawValue: rawValue) else {
            throw Keychain.Error.cast
        }
        return decoded.realValue
    }

}

extension Keychain.Coder.Enum : IKeychainValueEncoder where EnumCoder : IEnumEncodable, RawCoder : IKeychainValueEncoder, EnumCoder.RawValue == RawCoder.KeychainEncoded {
    
    public static func encode(_ value: EnumCoder.RealValue) throws -> Data {
        let encoded = EnumCoder(realValue: value)
        return try RawCoder.encode(encoded.rawValue)
    }
    
}

extension IKeychainDecoderAlias where Self : IEnumDecodable, RawValue : IKeychainDecoderAlias, RawValue == RawValue.KeychainDecoder.KeychainDecoded {
    
    public typealias KeychainDecoder = Keychain.Coder.Enum< Self, Self.RawValue.KeychainDecoder >
    
}

extension IKeychainEncoderAlias where Self : IEnumEncodable, RawValue : IKeychainEncoderAlias, RawValue == RawValue.KeychainEncoder.KeychainEncoded {
    
    public typealias KeychainEncoder = Keychain.Coder.Enum< Self, Self.RawValue.KeychainEncoder >
    
}
