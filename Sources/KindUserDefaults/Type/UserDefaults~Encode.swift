//
//  KindKit
//

import Foundation

public extension UserDefaults {
    
    @inlinable
    func encode< Encoder : IValueEncoder >(
        _ encoder: Encoder.Type,
        value: Encoder.UserDefaultsEncoded,
        forKey key: String
    ) {
        if let value = try? encoder.encode(value) {
            self.set(value, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
    }
    
    @inlinable
    func encode< Alias : IEncoderAlias >(
        _ alias: Alias.Type,
        value: Alias.UserDefaultsEncoder.UserDefaultsEncoded,
        forKey key: String
    ) {
        self.encode(Alias.UserDefaultsEncoder.self, value: value, forKey: key)
    }
    
}

public extension UserDefaults {
    
    @inlinable
    func encode< Encoder : IValueEncoder, Key : RawRepresentable >(
        _ encoder: Encoder.Type,
        value: Encoder.UserDefaultsEncoded,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    @inlinable
    func encode< Alias : IEncoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        value: Alias.UserDefaultsEncoder.UserDefaultsEncoded,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}

public extension UserDefaults {
    
    @inlinable
    func encode< Encoder : IValueEncoder >(
        _ encoder: Encoder.Type,
        value: Encoder.UserDefaultsEncoded?,
        forKey key: String
    ) {
        if let value = value {
            self.encode(encoder, value: value, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
    }
    
    @inlinable
    func encode< Alias : IEncoderAlias >(
        _ alias: Alias.Type,
        value: Alias.UserDefaultsEncoder.UserDefaultsEncoded?,
        forKey key: String
    ) {
        self.encode(Alias.UserDefaultsEncoder.self, value: value, forKey: key)
    }
    
}

public extension UserDefaults {
    
    @inlinable
    func encode< Encoder : IValueEncoder, Key : RawRepresentable >(
        _ encoder: Encoder.Type,
        value: Encoder.UserDefaultsEncoded?,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    @inlinable
    func encode< Alias : IEncoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        value: Alias.UserDefaultsEncoder.UserDefaultsEncoded?,
        forKey key: Key
    ) where Key.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}
