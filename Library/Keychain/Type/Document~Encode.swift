//
//  KindKit
//

import Foundation
import KindCodingOptions
import KindJSON

public extension Document {
    
    @inlinable
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded,
        in key: String
    ) throws where Encoder.KeychainEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, in: key, with: .default)
    }
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.KeychainEncoded,
        in key: String,
        with options: Encoder.KeychainEncodeOptions
    ) throws {
        if let value = try Encoder.keychain(encode: value, in: key, with: options) {
            self.set(value, in: key)
        } else {
            self.remove(in: key)
        }
    }
    
    @inlinable
    func encode< Encoder : KindJSON.ModelEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        in key: String
    ) throws where Encoder.JsonEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, in: key, with: .default)
    }
    
    func encode< Encoder : KindJSON.ModelEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.JsonEncoded,
        in key: String,
        with options: Encoder.JsonEncodeOptions
    ) throws  {
        try self.encode(JsonEncoder< Encoder >.self, value: value, in: key, with: options)
    }
    
}
