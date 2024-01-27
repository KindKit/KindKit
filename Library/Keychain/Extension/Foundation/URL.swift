//
//  KindKit
//

import Foundation
import KindCodingOptions

extension URL : ValueDecoderTrait {
    
    public typealias KeychainDecoded = Self
    public typealias KeychainDecodeOptions = URLDecodeOptions
    
    public static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        let string = try String.keychain(decode: value, in: key, with: .nonEmpty)
        guard let url = URL(string: string, relativeTo: options.base) else {
            throw CodingError(in: key)
        }
        guard options.require.validate(url: url) == true else {
            throw CodingError(in: key)
        }
        return url.absoluteURL
    }
    
}

extension URL : ValueEncoderTrait {
    
    public typealias KeychainEncoded = Self
    public typealias KeychainEncodeOptions = URLEncodeOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        guard let url = options.removing.removing(url: value) else {
            throw CodingError(in: key)
        }
        return try String.keychain(encode: url.absoluteString, in: key)
    }
    
}
