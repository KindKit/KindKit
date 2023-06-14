//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Date : IDatabaseValueCoder {
        
        public typealias DatabaseDecoded = Foundation.Date
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .init(timeIntervalSince1970: TimeInterval(value))
            case .real(let value):
                return .kk_date(julianDays: value)
            case .text(let value):
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                guard let date = formatter.date(from: value) else {
                    throw Database.Error.decode
                }
                return date
            case .blob:
                throw Database.Error.decode
            }
        }
        
        public static func encode(_ value: DatabaseDecoded) throws -> Database.Value {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return .text(formatter.string(from: value))
        }
        
    }
    
}

extension Date : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Integer
    
}

extension Date : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Date
    
}
