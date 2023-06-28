//
//  KindKit
//

import Foundation

public extension Database.ValueCoder.Date {
    
    struct JulianDays : IDatabaseValueCoder {
        
        public typealias DatabaseDecoded = Foundation.Date
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .kk_date(julianDays: Double(value))
            case .real(let value):
                return .kk_date(julianDays: value)
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Database.Error.decode
                }
                return .kk_date(julianDays: number.doubleValue)
            case .blob:
                throw Database.Error.decode
            }
        }
        
        public static func encode(_ value: DatabaseDecoded) throws -> Database.Value {
            return .real(value.kk_julianDays)
        }
        
    }
    
}
