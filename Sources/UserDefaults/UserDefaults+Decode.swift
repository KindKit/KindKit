//
//  KindKitCore
//

import Foundation
import KindKitCore

public extension UserDefaults {
    
    func decode< DecoderType: IUserDefaultsValueDecoder >(
        _ decoder: DecoderType.Type,
        forKey key: String
    ) -> DecoderType.ValueType? {
        guard let value = self.object(forKey: key) as? IUserDefaultsValue else { return nil }
        return try? decoder.decode(value)
    }
    
    func decode< AliasType: IUserDefaultsDecoderAlias >(
        _ alias: AliasType.Type,
        forKey key: String
    ) -> AliasType.UserDefaultsDecoderType.ValueType? {
        return self.decode(AliasType.UserDefaultsDecoderType.self, forKey: key)
    }
    
}

public extension UserDefaults {
    
    func decode< DecoderType: IUserDefaultsValueDecoder, KeyType: RawRepresentable >(
        _ decoder: DecoderType.Type,
        forKey key: KeyType
    ) -> DecoderType.ValueType? where KeyType.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue)
    }
    
    func decode< AliasType: IUserDefaultsDecoderAlias, KeyType: RawRepresentable >(
        _ alias: AliasType.Type,
        forKey key: KeyType
    ) -> AliasType.UserDefaultsDecoderType.ValueType? where KeyType.RawValue == String {
        return self.decode(alias, forKey: key.rawValue)
    }
    
}

public extension UserDefaults {
    
    func decode< DecoderType: IUserDefaultsValueDecoder >(
        _ decoder: DecoderType.Type,
        forKey key: String,
        default: DecoderType.ValueType
    ) -> DecoderType.ValueType {
        return self.decode(decoder, forKey: key) ?? `default`
    }
    
    func decode< AliasType: IUserDefaultsDecoderAlias >(
        _ alias: AliasType.Type,
        forKey key: String,
        default: AliasType.UserDefaultsDecoderType.ValueType
    ) -> AliasType.UserDefaultsDecoderType.ValueType {
        return self.decode(alias, forKey: key) ?? `default`
    }
    
}

public extension UserDefaults {
    
    func decode< DecoderType: IUserDefaultsValueDecoder, KeyType: RawRepresentable >(
        _ decoder: DecoderType.Type,
        forKey key: KeyType,
        default: DecoderType.ValueType
    ) -> DecoderType.ValueType where KeyType.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue, default: `default`)
    }
    
    func decode< AliasType: IUserDefaultsDecoderAlias, KeyType: RawRepresentable >(
        _ alias: AliasType.Type,
        forKey key: KeyType,
        default: AliasType.UserDefaultsDecoderType.ValueType
    ) -> AliasType.UserDefaultsDecoderType.ValueType where KeyType.RawValue == String {
        return self.decode(alias, forKey: key.rawValue, default: `default`)
    }
    
}
