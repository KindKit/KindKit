//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Array : ValueDecoderTrait where Element : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = Array< Element.UserDefaultsDecoded >
    public typealias UserDefaultsDecodeOptions = ArrayDecodeOptions< Element.UserDefaultsDecodeOptions >
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        guard let array = field as? NSArray else {
            throw CodingError(by: key)
        }
        var result: [Element.UserDefaultsDecoded] = []
        for index in 0 ..< array.count {
            do {
                result.append(try Element.userDefaults(decode: array[index] as! Field, by: key, with: options.element))
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

extension Array : ValueEncoderTrait where Element : ValueEncoderTrait, Element == Element.UserDefaultsEncoded {
    
    public typealias UserDefaultsEncoded = Array< Element.UserDefaultsEncoded >
    public typealias UserDefaultsEncodeOptions = ArrayEncodeOptions< Element.UserDefaultsEncodeOptions >
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        if options.sequence.contains(.nonEmpty) == true && value.isEmpty == true {
            throw CodingError(by: key)
        }
        let result = NSMutableArray(capacity: value.count)
        for index in value.indices {
            do {
                let element = try Element.userDefaults(encode: value[index], by: key, with: options.element)
                if let element = element {
                    result.add(element)
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
