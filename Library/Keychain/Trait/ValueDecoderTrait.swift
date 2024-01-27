//
//  KindKit
//

import Foundation
import KindCodingOptions

public protocol ValueDecoderTrait {
    
    associatedtype KeychainDecoded
    associatedtype KeychainDecodeOptions : CodingOptions
    
    static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded
    static func keychain(decode error: AccessError, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded
    
}

public extension ValueDecoderTrait {
    
    static func keychain(decode error: AccessError, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        throw CodingError(in: key)
    }
    
}

public extension ValueDecoderTrait where KeychainDecodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func keychain(decode value: Data, in key: String) throws -> KeychainDecoded {
        return try self.keychain(decode: value, in: key, with: .default)
    }
    
    @inlinable
    static func keychain(decode error: AccessError, in key: String) throws -> KeychainDecoded {
        return try self.keychain(decode: error, in: key, with: .default)
    }
    
}
