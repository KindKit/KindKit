//
//  KindKit
//

import Foundation
import KindCodingOptions
import KindJSON

public extension Document {
    
    @inlinable
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        in key: String
    ) throws -> Decoder.KeychainDecoded where Decoder.KeychainDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, in: key, with: .default)
    }
    
    @inlinable
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        in key: String,
        with options: Decoder.KeychainDecodeOptions
    ) throws -> Decoder.KeychainDecoded {
        if let value = self.get(in: key) {
            return try Decoder.keychain(decode: value, in: key, with: options)
        }
        return try Decoder.keychain(decode: AccessError(in: key), in: key, with: options)
    }
    
    @inlinable
    func decode< Decoder : KindJSON.ModelDecoderTrait >(
        _ decoder: Decoder.Type,
        in key: String
    ) throws -> Decoder.JsonDecoded where Decoder.JsonDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, in: key, with: .default)
    }
    
    func decode< Decoder : KindJSON.ModelDecoderTrait >(
        _ decoder: Decoder.Type,
        in key: String,
        with options: Decoder.JsonDecodeOptions
    ) throws -> Decoder.JsonDecoded {
        return try self.decode(JsonDecoder< Decoder >.self, in: key, with: options)
    }
    
}
