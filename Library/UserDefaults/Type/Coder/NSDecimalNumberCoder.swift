//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct NSDecimalNumberCoder : ValueCoderTrait {
    
    public typealias UserDefaultsDecoded = NSDecimalNumber
    public typealias UserDefaultsDecodeOptions = EmptyCodingOptions
    
    public typealias UserDefaultsEncoded = NSDecimalNumber
    public typealias UserDefaultsEncodeOptions = EmptyCodingOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        if let decimalNumber = field as? NSDecimalNumber {
            return decimalNumber
        } else if let number = field as? NSNumber {
            return .init(string: number.stringValue)
        } else if let string = field as? NSString {
            if let decimalNumber = NSDecimalNumber.kk_decimalNumber(from: string) {
                return decimalNumber
            }
        }
        throw CodingError(by: key)
    }
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        return value
    }
    
}
