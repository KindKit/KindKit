//
//  KindKit
//

import Foundation
import KindCore

extension ValueDecoderTrait where Self : RawRepresentable, RawValue : ValueDecoderTrait, RawValue == RawValue.KeychainDecoded {
    
    public static func keychain(decode value: Data, in key: String, with options: RawValue.KeychainDecodeOptions) throws -> Self {
        let value = try RawValue.keychain(decode: value, in: key, with: options)
        guard let value = Self.init(rawValue: value) else {
            throw CodingError(in: key)
        }
        return value
    }

}

extension ValueEncoderTrait where Self : RawRepresentable, RawValue : ValueEncoderTrait, RawValue == RawValue.KeychainEncoded {
    
    public static func keychain(encode value: Self, in key: String, with options: RawValue.KeychainEncodeOptions) throws -> Data? {
        return try RawValue.keychain(encode: value.rawValue, in: key, with: options)
    }
    
}
