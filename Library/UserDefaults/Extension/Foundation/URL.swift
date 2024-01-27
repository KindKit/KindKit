//
//  KindKit
//

import Foundation
import KindCodingOptions

extension URL : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = Self
    public typealias UserDefaultsDecodeOptions = URLDecodeOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        let string = try String.userDefaults(decode: field, by: key, with: .nonEmpty)
        guard let url = URL(string: string, relativeTo: options.base) else {
            throw CodingError(by: key)
        }
        guard options.require.validate(url: url) == true else {
            throw CodingError(by: key)
        }
        return url.absoluteURL
    }
    
}

extension URL : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = Self
    public typealias UserDefaultsEncodeOptions = URLEncodeOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        guard let url = options.removing.removing(url: value) else {
            throw CodingError(by: key)
        }
        return try String.userDefaults(encode: url.absoluteString, by: key)
    }
    
}
