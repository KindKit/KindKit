//
//  KindKit
//

import Foundation
import KindNumeric

extension ValueEncoderTrait where Self : ToNSNumberTrait {
    
    public static func json(encode value: Self, in path: Path, with options: NSNumberCoder.JsonEncodeOptions) throws -> Field? {
        return try NSNumberCoder.json(encode: value.nsNumber, in: path, with: options)
    }
    
}
