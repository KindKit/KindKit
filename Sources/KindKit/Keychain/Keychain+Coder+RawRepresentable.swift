//
//  KindKit
//

import Foundation

public extension Keychain.Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension Keychain.Coder.RawRepresentable : IKeychainValueDecoder where RawCoder : IKeychainValueDecoder, Enum.RawValue == RawCoder.KeychainDecoded {
    
    public static func decode(_ value: Data) throws -> Enum {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Keychain.Error.cast
        }
        guard let decoded = Enum(rawValue: rawValue) else {
            throw Keychain.Error.cast
        }
        return decoded
    }

}

extension Keychain.Coder.RawRepresentable : IKeychainValueEncoder where RawCoder : IKeychainValueEncoder, Enum.RawValue == RawCoder.KeychainEncoded {
    
    public static func encode(_ value: Enum) throws -> Data {
        return try RawCoder.encode(value.rawValue)
    }
    
}
