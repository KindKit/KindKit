//
//  KindKit
//

import Foundation

public extension Keychain {
    
    @inlinable
    func decode< Decoder : IKeychainValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String
    ) -> Decoder.KeychainDecoded? {
        guard let value = self.get(key) else { return nil }
        return try? decoder.decode(value)
    }
    
    @inlinable
    func decode< Alias : IKeychainDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String
    ) -> Alias.KeychainDecoder.KeychainDecoded? {
        return self.decode(Alias.KeychainDecoder.self, forKey: key)
    }
    
}

public extension Keychain {
    
    @inlinable
    func decode< Decoder : IKeychainValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key
    ) -> Decoder.KeychainDecoded? where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue)
    }
    
    @inlinable
    func decode< Alias : IKeychainDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key
    ) -> Alias.KeychainDecoder.KeychainDecoded? where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue)
    }
    
}

public extension Keychain {
    
    @inlinable
    func decode< Decoder : IKeychainValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String,
        default: Decoder.KeychainDecoded
    ) -> Decoder.KeychainDecoded {
        return self.decode(decoder, forKey: key) ?? `default`
    }
    
    @inlinable
    func decode< Alias : IKeychainDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String,
        default: Alias.KeychainDecoder.KeychainDecoded
    ) -> Alias.KeychainDecoder.KeychainDecoded {
        return self.decode(alias, forKey: key) ?? `default`
    }
    
}

public extension Keychain {
    
    @inlinable
    func decode< Decoder : IKeychainValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key,
        default: Decoder.KeychainDecoded
    ) -> Decoder.KeychainDecoded where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue, default: `default`)
    }
    
    @inlinable
    func decode< Alias : IKeychainDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key,
        default: Alias.KeychainDecoder.KeychainDecoded
    ) -> Alias.KeychainDecoder.KeychainDecoded where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue, default: `default`)
    }
    
}
