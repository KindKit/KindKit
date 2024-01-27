//
//  KindKit
//

import Foundation

public extension ValueCoder.Date {
    
    struct Standart : IValueCoder {
        
        public typealias SQLiteDecoded = Foundation.Date
        
        public static func decode(_ value: Value) throws -> SQLiteDecoded {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return .kk_date(unixTime: value)
            case .real(let value):
                return .kk_date(julianDays: value)
            case .text(let value):
                let formatter = Foundation.DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                guard let date = formatter.date(from: value) else {
                    throw Error.decode
                }
                return date
            case .blob:
                throw Error.decode
            }
        }
        
        public static func encode(_ value: SQLiteDecoded) throws -> Value {
            let formatter = Foundation.DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return .text(formatter.string(from: value))
        }
        
    }
    
}

extension Date : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Text
    
}

extension Date : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Date.Standart
    
}
