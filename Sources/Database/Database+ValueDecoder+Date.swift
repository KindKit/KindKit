//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct Date : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Foundation.Date {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .init(timeIntervalSince1970: TimeInterval(value))
            case .real(let value):
                return .init(timeIntervalSince1970: TimeInterval(value))
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
        
    }
    
}

extension Date : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Date
    
}
