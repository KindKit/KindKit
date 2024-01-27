//
//  KindKit
//

import Foundation
import KindCodingOptions

public extension Document {
    
    func decode<
        Success,
        Failure : Swift.Error
    >(
        success: (Document) throws -> Success,
        failure: (Document) throws -> Failure
    ) throws -> Result< Success, Failure > {
        do {
            return .success(try success(self))
        } catch let error {
            do {
                return .failure(try failure(self))
            } catch _ {
                throw error
            }
        }
    }
    
}

public extension Document {
    
    @inlinable
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        by key: String
    ) throws -> Decoder.UserDefaultsDecoded where Decoder.UserDefaultsDecodeOptions : DefaultCodingOptions {
        return try self.decode(decoder, by: key, with: .default)
    }
    
    func decode< Decoder : ValueDecoderTrait >(
        _ decoder: Decoder.Type,
        by key: String,
        with options: Decoder.UserDefaultsDecodeOptions
    ) throws -> Decoder.UserDefaultsDecoded {
        guard let value = self.storage.object(forKey: key) else {
            return try Decoder.userDefaults(decode: AccessError(by: key), with: options)
        }
        guard let value = value as? Field else {
            throw CodingError(by: key)
        }
        return try Decoder.userDefaults(decode: value, by: key, with: options)
    }
    
}
