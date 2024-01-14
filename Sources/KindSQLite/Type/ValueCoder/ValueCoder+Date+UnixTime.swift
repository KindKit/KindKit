//
//  KindKit
//

import Foundation

public extension ValueCoder.Date {
    
    struct UnixTime : IValueCoder {
        
        public typealias SQLiteDecoded = Foundation.Date
        
        public static func decode(_ value: Value) throws -> SQLiteDecoded {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return .kk_date(unixTime: value)
            case .real(let value):
                return .kk_date(unixTime: Int(value))
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Error.decode
                }
                return .kk_date(unixTime: number.intValue)
            case .blob:
                throw Error.decode
            }
        }
        
        public static func encode(_ value: SQLiteDecoded) throws -> Value {
            return .integer(value.kk_unixTime)
        }
        
    }
    
}
