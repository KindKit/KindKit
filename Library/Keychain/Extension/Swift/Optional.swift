//
//  KindKit
//

import Foundation
import KindCore
import KindCodingOptions

extension Optional : ValueDecoderTrait where Wrapped : ValueDecoderTrait, Wrapped == Wrapped.KeychainDecoded {
    
    public typealias KeychainDecoded = Self
    public typealias KeychainDecodeOptions = OptionalDecodeOptions< Wrapped.KeychainDecodeOptions, Wrapped >
    
    public static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        guard let value = try? Wrapped.keychain(decode: value, in: key, with: options.wrapped) else {
            return options.default
        }
        return .some(value)
    }
    
    public static func keychain(decode error: AccessError, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        return options.default
    }
    
}

extension Optional : ValueEncoderTrait where Wrapped : ValueEncoderTrait, Wrapped == Wrapped.KeychainEncoded {
    
    public typealias KeychainEncoded = Self
    public typealias KeychainEncodeOptions = Wrapped.KeychainEncodeOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        switch value {
        case .some(let value): return try Wrapped.keychain(encode: value, in: key, with: options)
        case .none: return nil
        }
    }
    
}
