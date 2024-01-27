//
//  KindKit
//

import Foundation
import KindNumeric
import KindCodingOptions

extension ValueDecoderTrait where Self : FromNSNumberTrait {
    
    public static func keychain(decode value: Data, in key: String, with options: EmptyCodingOptions) throws -> Self {
        let string = try String.keychain(decode: value, in: key, with: .nonEmpty)
        guard let nsNumber = NSNumber.kk_number(from: string) else {
            throw CodingError(in: key)
        }
        guard let value = Self.init(exactly: nsNumber) else {
            throw CodingError(in: key)
        }
        return value
    }
    
}
