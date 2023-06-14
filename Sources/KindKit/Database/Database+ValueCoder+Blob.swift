//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Blob : IDatabaseValueCoder {
        
        public typealias DatabaseDecoded = Foundation.Data
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
            switch value {
            case .null, .integer, .real:
                throw Database.Error.decode
            case .text(let value):
                guard let data = value.data(using: .utf8) else {
                    throw Database.Error.decode
                }
                return data
            case .blob(let value):
                return value
            }
        }
        
        public static func encode(_ value: DatabaseDecoded) throws -> Database.Value {
            return .blob(value)
        }
        
    }
    
}

extension Data : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Blob
    
}
