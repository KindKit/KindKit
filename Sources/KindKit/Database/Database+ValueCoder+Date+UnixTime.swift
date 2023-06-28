//
//  KindKit
//

import Foundation

public extension Database.ValueCoder.Date {
    
    struct UnitTime : IDatabaseValueCoder {
        
        public typealias DatabaseDecoded = Foundation.Date
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .kk_date(unixTime: value)
            case .real(let value):
                return .kk_date(unixTime: Int(value))
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Database.Error.decode
                }
                return .kk_date(unixTime: number.intValue)
            case .blob:
                throw Database.Error.decode
            }
        }
        
        public static func encode(_ value: DatabaseDecoded) throws -> Database.Value {
            return .integer(value.kk_unixTime)
        }
        
    }
    
}
