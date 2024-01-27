//
//  KindKit
//

import Foundation
import KindCodingOptions

extension String : ValueDecoderTrait {
    
    public typealias KeychainDecoded = String
    public typealias KeychainDecodeOptions = StringDecodeOptions
    
    public static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        guard let value = String(data: value, encoding: .utf8) else {
            throw CodingError(in: key)
        }
        if options.contains(.nonEmpty) && value.isEmpty {
            throw CodingError(in: key)
        }
        return value
    }
    
}

extension String : ValueEncoderTrait {
    
    public typealias KeychainEncoded = String
    public typealias KeychainEncodeOptions = EmptyCodingOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        guard let data = value.data(using: .utf8) else {
            throw CodingError(in: key)
        }
        return data
    }
    
}
