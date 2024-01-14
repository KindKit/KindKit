//
//  KindKit
//

import KindJSON

public extension ValueCoder {
    
    struct Identifier< ValueCoder : IValueCoder, Kind : IIdentifierKind > : IValueCoder {
        
        public typealias SQLiteCoded = KindJSON.Identifier< ValueCoder.SQLiteCoded, Kind >
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            return .init(try ValueCoder.decode(value))
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return try ValueCoder.encode(value.raw)
        }
        
    }
    
}

extension Identifier : IValueAlias where Raw : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Identifier< Raw.SQLiteValueCoder, Kind >
    
}
