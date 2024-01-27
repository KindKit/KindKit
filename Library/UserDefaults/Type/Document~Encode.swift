//
//  KindKit
//

import Foundation
import KindCodingOptions

public extension Document {
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.UserDefaultsEncoded,
        by key: String
    ) throws where Encoder.UserDefaultsEncodeOptions : DefaultCodingOptions {
        try self.encode(encoder, value: value, by: key, with: .default)
    }
    
    func encode< Encoder : ValueEncoderTrait >(
        _ encoder: Encoder.Type,
        value: Encoder.UserDefaultsEncoded,
        by key: String,
        with options: Encoder.UserDefaultsEncodeOptions
    ) throws {
        let value = try Encoder.userDefaults(encode: value, by: key, with: options)
        if let value = value {
            self.storage.set(value, forKey: key)
        }
    }
    
}
