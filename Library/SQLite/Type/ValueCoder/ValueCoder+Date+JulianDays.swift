//
//  KindKit
//

import Foundation

public extension ValueCoder.Date {
    
    struct JulianDays : IValueCoder {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Foundation.Date {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return .kk_date(julianDays: Double(value))
            case .real(let value):
                return .kk_date(julianDays: value)
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Error.decode
                }
                return .kk_date(julianDays: number.doubleValue)
            case .blob:
                throw Error.decode
            }
        }
        
        public static func encode(_ value: Foundation.Date) throws -> KindSQLite.Value {
            return .real(value.kk_julianDays)
        }
        
    }
    
}
