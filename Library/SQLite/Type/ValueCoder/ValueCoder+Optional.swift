//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Optional< Wrapped : IValueCoder > : IValueCoder {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Wrapped.SQLiteCoded? {
            switch value {
            case .null:
                return nil
            case .integer, .real, .text, .blob:
                return try Wrapped.decode(value)
            }
        }
        
        public static func encode(_ value: Wrapped.SQLiteCoded?) throws -> KindSQLite.Value {
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
