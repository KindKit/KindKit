//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    func decode< Decoder : IValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String
    ) -> Decoder.KeychainDecoded? {
        guard let value = self.get(key) else { return nil }
        return try? decoder.decode(value)
    }
    
    @inlinable
    func decode< Alias : IDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String
    ) -> Alias.KeychainDecoder.KeychainDecoded? {
        return self.decode(Alias.KeychainDecoder.self, forKey: key)
    }
    
}

public extension Document {
    
    @inlinable
    func decode< Decoder : IValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key
    ) -> Decoder.KeychainDecoded? where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue)
    }
    
    @inlinable
    func decode< Alias : IDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key
    ) -> Alias.KeychainDecoder.KeychainDecoded? where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue)
    }
    
}

public extension Document {
    
    @inlinable
    func decode< Decoder : IValueDecoder >(
        _ decoder: Decoder.Type,
        forKey key: String,
        default: Decoder.KeychainDecoded
    ) -> Decoder.KeychainDecoded {
        return self.decode(decoder, forKey: key) ?? `default`
    }
    
    @inlinable
    func decode< Alias : IDecoderAlias >(
        _ alias: Alias.Type,
        forKey key: String,
        default: Alias.KeychainDecoder.KeychainDecoded
    ) -> Alias.KeychainDecoder.KeychainDecoded {
        return self.decode(alias, forKey: key) ?? `default`
    }
    
}

public extension Document {
    
    @inlinable
    func decode< Decoder : IValueDecoder, Key : RawRepresentable >(
        _ decoder: Decoder.Type,
        forKey key: Key,
        default: Decoder.KeychainDecoded
    ) -> Decoder.KeychainDecoded where Key.RawValue == String {
        return self.decode(decoder, forKey: key.rawValue, default: `default`)
    }
    
    @inlinable
    func decode< Alias : IDecoderAlias, Key : RawRepresentable >(
        _ alias: Alias.Type,
        forKey key: Key,
        default: Alias.KeychainDecoder.KeychainDecoded
    ) -> Alias.KeychainDecoder.KeychainDecoded where Key.RawValue == String {
        return self.decode(alias, forKey: key.rawValue, default: `default`)
    }
    
}
