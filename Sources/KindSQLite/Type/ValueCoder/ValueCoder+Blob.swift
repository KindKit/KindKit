//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Blob : IValueCoder {
        
        public typealias SQLiteDecoded = Foundation.Data
        
        public static func decode(_ value: Value) throws -> SQLiteDecoded {
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
        
        public static func encode(_ value: SQLiteDecoded) throws -> Value {
            return .blob(value)
        }
        
    }
    
}

extension Data : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Blob
    
}
