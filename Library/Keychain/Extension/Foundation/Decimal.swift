//
//  KindKit
//

import Foundation
import KindCore

extension Decimal : ValueDecoderTrait {
    
    public typealias KeychainDecoded = Self
    public typealias KeychainDecodeOptions = EmptyCodingOptions
    
    public static func keychain(decode value: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        let string = try String.keychain(decode: value, in: key, with: .nonEmpty)
        guard let decimalNumber = NSDecimalNumber.kk_decimalNumber(from: string as NSString) else {
            throw CodingError(in: key)
        }
        return decimalNumber as Decimal
    }
    
}

extension Decimal : ValueEncoderTrait {
    
    public typealias KeychainEncoded = Self
    public typealias KeychainEncodeOptions = EmptyCodingOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX");
        formatter.formatterBehavior = .behavior10_4;
        formatter.numberStyle = .none;
        
        guard let string = formatter.string(from: value as NSNumber) else {
            throw CodingError(in: key)
        }
        return try String.keychain(encode: string, in: key, with: options)
    }
    
}
