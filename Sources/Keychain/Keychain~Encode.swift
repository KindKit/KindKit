//
//  KindKit
//

import Foundation

public extension Keychain {
    
    @inlinable
    func encode< Encoder : IKeychainValueEncoder >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded,
        forKey key: String
    ) {
        if let value = try? encoder.encode(value) {
            self.set(value, key: key)
        } else {
            self.remove(key)
        }
    }
    
    @inlinable
    func encode< Alias : IKeychainEncoderAlias >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded,
        forKey key: String
    ) {
        self.encode(Alias.KeychainEncoder.self, value: value, forKey: key)
    }
    
}

public extension Keychain {
    
    @inlinable
    func encode< Encoder : IKeychainValueEncoder, Key : RawRepresentable >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    @inlinable
    func encode< Alias : IKeychainEncoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}

public extension Keychain {
    
    @inlinable
    func encode< Encoder : IKeychainValueEncoder >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded?,
        forKey key: String
    ) {
        if let value = value {
            self.encode(encoder, value: value, forKey: key)
        } else {
            self.remove(key)
        }
    }
    
    @inlinable
    func encode< Alias : IKeychainEncoderAlias >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded?,
        forKey key: String
    ) {
        self.encode(Alias.KeychainEncoder.self, value: value, forKey: key)
    }
    
}

public extension Keychain {
    
    @inlinable
    func encode< Encoder : IKeychainValueEncoder, Key : RawRepresentable >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded?,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    @inlinable
    func encode< Alias : IKeychainEncoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded?,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}
