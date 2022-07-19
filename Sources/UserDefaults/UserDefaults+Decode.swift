//
//  KindKitCore
//

import Foundation
import KindKitCore

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String
    ) -> Decoder.Value? {
        guard let value = self.object(forKey: key) as? IUserDefaultsValue else { return nil }
        return try? decoder.decode(value)
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String
    ) -> Alias.UserDefaultsDecoder.Value? {
        return self.decode(Alias.UserDefaultsDecoder.self, forKey: key)
    }
    
}

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key
    ) -> Decoder.Value? where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue)
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key
    ) -> Alias.UserDefaultsDecoder.Value? where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue)
    }
    
}

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String,
        default: Decoder.Value
    ) -> Decoder.Value {
        return self.decode(decoder, forKey: key) ?? `default`
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String,
        default: Alias.UserDefaultsDecoder.Value
    ) -> Alias.UserDefaultsDecoder.Value {
        return self.decode(alias, forKey: key) ?? `default`
    }
    
}

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key,
        default: Decoder.Value
    ) -> Decoder.Value where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue, default: `default`)
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key,
        default: Alias.UserDefaultsDecoder.Value
    ) -> Alias.UserDefaultsDecoder.Value where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue, default: `default`)
    }
    
}
