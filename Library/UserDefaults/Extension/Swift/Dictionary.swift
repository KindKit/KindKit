//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Dictionary : ValueDecoderTrait where Key : ValueDecoderTrait, Value : ValueDecoderTrait, Key.UserDefaultsDecoded : Hashable {
    
    public typealias UserDefaultsDecoded = Dictionary< Key.UserDefaultsDecoded, Value.UserDefaultsDecoded >
    public typealias UserDefaultsDecodeOptions = DictionaryDecodeOptions< Key.UserDefaultsDecodeOptions, Value.UserDefaultsDecodeOptions >
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        guard let dictionary = field as? NSDictionary else {
            throw CodingError(by: key)
        }
        var result: [Key.UserDefaultsDecoded: Value.UserDefaultsDecoded] = [:]
        for item in dictionary {
            do {
                let decodedKey = try Key.userDefaults(decode: item.key as! Field, by: key, with: options.key)
                result[decodedKey] = try Value.userDefaults(decode: item.value as! Field, by: key, with: options.value)
            } catch let error {
                if options.sequence.contains(.skipInvalid) == true {
                    continue
                }
                throw error
            }
        }
        if options.sequence.contains(.nonEmpty) == true && result.isEmpty == true {
            throw CodingError(by: key)
        }
        return result
    }
    
}

extension Dictionary : ValueEncoderTrait where Key : ValueEncoderTrait, Value : ValueEncoderTrait, Key.UserDefaultsEncoded : Hashable {
    
    public typealias UserDefaultsEncoded = Dictionary< Key.UserDefaultsEncoded, Value.UserDefaultsEncoded >
    public typealias UserDefaultsEncodeOptions = DictionaryEncodeOptions< Key.UserDefaultsEncodeOptions, Value.UserDefaultsEncodeOptions >
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        if options.sequence.contains(.nonEmpty) == true && value.isEmpty == true {
            throw CodingError(by: key)
        }
        let result = NSMutableDictionary(capacity: value.count)
        for item in value {
            do {
                let encodedKey = try Key.userDefaults(encode: item.key, by: key, with: options.key)
                let encodedValue = try Value.userDefaults(encode: item.value, by: key, with: options.value)
                if let encodedKey = encodedKey, let encodedValue = encodedValue {
                    result.setObject(encodedValue, forKey: encodedKey as! NSCopying)
                }
            } catch let error {
                if options.sequence.contains(.skipInvalid) == true {
                    continue
                }
                throw error
            }
        }
        return result
    }
    
}
