//
//  KindKit
//

import Foundation
import KindCodingOptions

public protocol ValueEncoderTrait {
    
    associatedtype KeychainEncoded
    associatedtype KeychainEncodeOptions : CodingOptions
    
    static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data?
    
}

public extension ValueEncoderTrait where KeychainEncodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func keychain(encode value: KeychainEncoded, in key: String) throws -> Data? {
        return try self.keychain(encode: value, in: key, with: .default)
    }
    
}
