//
//  KindKit
//

import Foundation
import KindNumeric
import KindCodingOptions

extension ValueEncoderTrait where Self : ToNSNumberTrait {
    
    public static func keychain(encode value: Self, in key: String, with options: EmptyCodingOptions) throws -> Data? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX");
        formatter.formatterBehavior = .behavior10_4;
        formatter.numberStyle = .none;
        
        guard let string = formatter.string(from: value.nsNumber) else {
            throw CodingError(in: key)
        }
        return try String.keychain(encode: string, in: key, with: options)
    }
    
}
