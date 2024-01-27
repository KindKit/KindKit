//
//  KindKit
//

import Foundation
import KindCore

extension Identifier : ValueDecoderTrait where Raw : ValueDecoderTrait, Raw == Raw.KeychainDecoded {
    
    public typealias KeychainDecoded = Self
    public typealias KeychainDecodeOptions = Raw.KeychainDecodeOptions
    
    public static func keychain(decode field: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        let value = try Raw.keychain(decode: field, in: key, with: options)
        return .init(value)
    }
    
}

extension Identifier : ValueEncoderTrait where Raw : ValueEncoderTrait, Raw == Raw.KeychainEncoded {
    
    public typealias KeychainEncoded = Self
    public typealias KeychainEncodeOptions = Raw.KeychainEncodeOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        return try Raw.keychain(encode: value.raw, in: key, with: options)
    }
    
}
