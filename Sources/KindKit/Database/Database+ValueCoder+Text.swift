//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Text : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = Swift.String
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .init(value)
            case .real(let value):
                return .init(value)
            case .text(let value):
                return value
            case .blob(let value):
                guard let string = Swift.String(data: value, encoding: .utf8) else {
                    throw Database.Error.decode
                }
                return string
            }
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            return .text(value)
        }
        
    }
    
}

extension String : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Text
    
}
