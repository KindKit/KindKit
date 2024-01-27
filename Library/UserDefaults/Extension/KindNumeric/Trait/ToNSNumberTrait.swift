//
//  KindKit
//

import Foundation
import KindNumeric

extension ValueEncoderTrait where Self : ToNSNumberTrait {
    
    public static func userDefaults(encode value: Self, by key: String, with options: NSNumberCoder.UserDefaultsEncodeOptions) throws -> Field? {
        return try NSNumberCoder.userDefaults(encode: value.nsNumber, by: key, with: options)
    }
    
}
