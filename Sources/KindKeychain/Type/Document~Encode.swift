//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    func encode< Encoder : IValueEncoder >(
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
    func encode< Alias : IEncoderAlias >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded,
        forKey key: String
    ) {
        self.encode(Alias.KeychainEncoder.self, value: value, forKey: key)
    }
    
}

public extension Document {
    
    @inlinable
    func encode< Encoder : IValueEncoder, Key : RawRepresentable >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    @inlinable
    func encode< Alias : IEncoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}

public extension Document {
    
    @inlinable
    func encode< Encoder : IValueEncoder >(
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
    func encode< Alias : IEncoderAlias >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded?,
        forKey key: String
    ) {
        self.encode(Alias.KeychainEncoder.self, value: value, forKey: key)
    }
    
}

public extension Document {
    
    @inlinable
    func encode< Encoder : IValueEncoder, Key : RawRepresentable >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded?,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    @inlinable
    func encode< Alias : IEncoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        value: Alias.KeychainEncoder.KeychainEncoded?,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}
