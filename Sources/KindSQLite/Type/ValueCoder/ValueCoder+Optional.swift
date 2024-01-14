//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Optional< Wrapped : IValueCoder > : IValueCoder {
        
        public typealias SQLiteCoded = Wrapped.SQLiteCoded?
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            switch value {
            case .null:
                return nil
            case .integer, .real, .text, .blob:
                return try Wrapped.decode(value)
            }
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            guard let value = value else {
                return .null
            }
            return try Wrapped.encode(value)
        }
        
    }
    
}

extension Optional : IValueAlias where Wrapped : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Optional< Wrapped.SQLiteValueCoder >
    
}
