//
//  KindKit
//

import Foundation
import KindCore
import KindCodingOptions

extension Optional : ValueDecoderTrait where Wrapped : ValueDecoderTrait, Wrapped == Wrapped.UserDefaultsDecoded {
    
    public typealias UserDefaultsDecoded = Self
    public typealias UserDefaultsDecodeOptions = OptionalDecodeOptions< Wrapped.UserDefaultsDecodeOptions, Wrapped >
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        guard let value = try? Wrapped.userDefaults(decode: field, by: key, with: options.wrapped) else {
            return options.default
        }
        return .some(value)
    }
    
    public static func userDefaults(decode error: AccessError, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        return options.default
    }
    
}

extension Optional : ValueEncoderTrait where Wrapped : ValueEncoderTrait, Wrapped == Wrapped.UserDefaultsEncoded {
    
    public typealias UserDefaultsEncoded = Self
    public typealias UserDefaultsEncodeOptions = OptionalEncodeOptions< Wrapped.UserDefaultsEncodeOptions >
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        switch value {
        case .some(let value):
            return try Wrapped.userDefaults(encode: value, by: key, with: options.wrapped)
        case .none:
            switch options.options {
            case .skippable: return nil
            case .nullable: return NSNull()
            }
        }
    }
    
}
