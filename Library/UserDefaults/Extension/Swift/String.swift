//
//  KindKit
//

import Foundation
import KindCodingOptions

extension String : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = String
    public typealias UserDefaultsDecodeOptions = StringDecodeOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        let value = try NSStringCoder.userDefaults(decode: field, by: key)
        if options.contains(.nonEmpty) == true {
            if value.length == 0 {
                throw CodingError(by: key)
            }
        }
        return value as String
    }
    
}

extension String : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = String
    public typealias UserDefaultsEncodeOptions = EmptyCodingOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return try NSStringCoder.userDefaults(encode: value as NSString, by: key, with: options)
    }
    
}
