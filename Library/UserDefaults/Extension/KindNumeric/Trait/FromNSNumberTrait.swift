//
//  KindKit
//

import Foundation
import KindNumeric

extension ValueDecoderTrait where Self : FromNSNumberTrait {
    
    public static func userDefaults(decode field: Field, by key: String, with options: NSNumberCoder.UserDefaultsDecodeOptions) throws -> Self {
        let nsNumber = try NSNumberCoder.userDefaults(decode: field, by: key, with: options)
        guard let value = Self.init(exactly: nsNumber) else {
            throw CodingError(by: key)
        }
        return value
    }
    
}
