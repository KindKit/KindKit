//
//  KindKit
//

import Foundation

extension UInt {
    
    @inlinable
    static func kk_make(string: String, radix: UInt) -> Self? {
        var result = UInt(0)
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        for digit in string.lowercased() {
            if let index = digits.firstIndex(of: digit) {
                let val = UInt(digits.distance(from: digits.startIndex, to: index))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        return result
    }
    
}
