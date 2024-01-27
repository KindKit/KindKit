//
//  KindKit
//

import KindJSON

public extension ValueCoder {
    
    struct Identifier< ValueCoderType : IValueCoder, KindType : IIdentifierKind > : IValueCoder where ValueCoderType.SQLiteCoded : Hashable {
        
        public typealias SQLiteCoded = KindJSON.Identifier< ValueCoderType.SQLiteCoded, KindType >
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            return .init(try ValueCoderType.decode(value))
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return try ValueCoderType.encode(value.id)
        }
        
    }
    
}

extension Identifier : IValueAlias where RawType : IValueAlias, RawType.SQLiteValueCoder.SQLiteCoded : Hashable {
    
    public typealias SQLiteValueCoder = ValueCoder.Identifier< RawType.SQLiteValueCoder, KindType >
    
}
