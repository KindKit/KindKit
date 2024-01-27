//
//  KindKit
//

import Foundation
import KindCore

extension SemaVersion : ValueDecoderTrait {
    
    public typealias KeychainDecoded = SemaVersion
    public typealias KeychainDecodeOptions = String.KeychainDecodeOptions
    
    public static func keychain(decode field: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        let value = try String.keychain(decode: field, in: key, with: options)
        guard let value = SemaVersion(value) else {
            throw CodingError(in: key)
        }
        return value
    }
    
}

extension SemaVersion : ValueEncoderTrait {
    
    public typealias KeychainEncoded = SemaVersion
    public typealias KeychainEncodeOptions = SemaVersion.MakeOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        return try String.keychain(encode: value.make(options: options), in: key)
    }
    
}
