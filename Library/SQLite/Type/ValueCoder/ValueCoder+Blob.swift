//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Blob : IValueCoder {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Foundation.Data {
            switch value {
            case .null, .integer, .real:
                throw Error.decode
            case .text(let value):
                guard let data = value.data(using: .utf8) else {
                    throw Error.decode
                }
                return data
            case .blob(let value):
                return value
            }
        }
        
        public static func encode(_ value: Foundation.Data) throws -> KindSQLite.Value {
            return .blob(value)
        }
        
    }
    
}

extension Data : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Blob
    
}
