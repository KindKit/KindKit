//
//  KindKit
//

import Foundation
import KindNumeric

extension ValueDecoderTrait where Self : FromNSNumberTrait {
    
    public static func json(decode field: Field, in path: Path, with options: NSNumberCoder.JsonDecodeOptions) throws -> Self {
        let nsNumber = try NSNumberCoder.json(decode: field, in: path, with: options)
        guard let value = Self.init(exactly: nsNumber) else {
            throw CodingError(in: path)
        }
        return value
    }
    
}
