//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Text : IValueCoder {
        
        public typealias SQLiteCoded = Swift.String
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return .init(value)
            case .real(let value):
                return .init(value)
            case .text(let value):
                return value
            case .blob(let value):
                guard let string = Swift.String(data: value, encoding: .utf8) else {
                    throw Error.decode
                }
                return string
            }
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return .text(value)
        }
        
    }
    
}

extension String : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Text
    
}
