//
//  KindKitCore
//

import Foundation
import KindKitCore

public extension UserDefaults {
    
    func encode< EncoderType: IUserDefaultsValueEncoder >(
        _ encoder: EncoderType.Type,
        value: EncoderType.ValueType,
        forKey key: String
    ) {
        if let value = try? encoder.encode(value) {
            self.set(value, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
    }
    
    func encode< AliasType: IUserDefaultsEncoderAlias >(
        _ alias: AliasType.Type,
        value: AliasType.UserDefaultsEncoderType.ValueType,
        forKey key: String
    ) {
        self.encode(AliasType.UserDefaultsEncoderType.self, value: value, forKey: key)
    }
    
}

public extension UserDefaults {
    
    func encode< EncoderType: IUserDefaultsValueEncoder, KeyType: RawRepresentable >(
        _ encoder: EncoderType.Type,
        value: EncoderType.ValueType,
        forKey key: KeyType
    ) where KeyType.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    func encode< AliasType: IUserDefaultsEncoderAlias, KeyType: RawRepresentable >(
        _ alias: AliasType.Type,
        value: AliasType.UserDefaultsEncoderType.ValueType,
        forKey key: KeyType
    ) where KeyType.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}

public extension UserDefaults {
    
    func encode< EncoderType: IUserDefaultsValueEncoder >(
        _ encoder: EncoderType.Type,
        value: EncoderType.ValueType?,
        forKey key: String
    ) {
        if let value = value {
            self.encode(encoder, value: value, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
    }
    
    func encode< AliasType: IUserDefaultsEncoderAlias >(
        _ alias: AliasType.Type,
        value: AliasType.UserDefaultsEncoderType.ValueType?,
        forKey key: String
    ) {
        self.encode(AliasType.UserDefaultsEncoderType.self, value: value, forKey: key)
    }
    
}

public extension UserDefaults {
    
    func encode< EncoderType: IUserDefaultsValueEncoder, KeyType: RawRepresentable >(
        _ encoder: EncoderType.Type,
        value: EncoderType.ValueType?,
        forKey key: KeyType
    ) where KeyType.RawValue == String {
        self.encode(encoder, value: value, forKey: key.rawValue)
    }
    
    func encode< AliasType: IUserDefaultsEncoderAlias, KeyType: RawRepresentable >(
        _ alias: AliasType.Type,
        value: AliasType.UserDefaultsEncoderType.ValueType?,
        forKey key: KeyType
    ) where KeyType.RawValue == String {
        self.encode(alias, value: value, forKey: key.rawValue)
    }
    
}
