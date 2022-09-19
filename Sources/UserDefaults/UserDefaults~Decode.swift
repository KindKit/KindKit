//
//  KindKit
//

import Foundation

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String
    ) -> Decoder.UserDefaultsDecoded? {
        guard let value = self.object(forKey: key) as? IUserDefaultsValue else { return nil }
        return try? decoder.decode(value)
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String
    ) -> Alias.UserDefaultsDecoder.UserDefaultsDecoded? {
        return self.decode(Alias.UserDefaultsDecoder.self, forKey: key)
    }
    
}

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key
    ) -> Decoder.UserDefaultsDecoded? where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue)
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key
    ) -> Alias.UserDefaultsDecoder.UserDefaultsDecoded? where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue)
    }
    
}

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String,
        default: Decoder.UserDefaultsDecoded
    ) -> Decoder.UserDefaultsDecoded {
        return self.decode(decoder, forKey: key) ?? `default`
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String,
        default: Alias.UserDefaultsDecoder.UserDefaultsDecoded
    ) -> Alias.UserDefaultsDecoder.UserDefaultsDecoded {
        return self.decode(alias, forKey: key) ?? `default`
    }
    
}

public extension UserDefaults {
    
    func decode< Decoder : IUserDefaultsValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key,
        default: Decoder.UserDefaultsDecoded
    ) -> Decoder.UserDefaultsDecoded where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue, default: `default`)
    }
    
    func decode< Alias : IUserDefaultsDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key,
        default: Alias.UserDefaultsDecoder.UserDefaultsDecoded
    ) -> Alias.UserDefaultsDecoder.UserDefaultsDecoded where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue, default: `default`)
    }
    
}
