//
//  KindKit
//

import KindCore

public extension ValueCoder {
    
    struct Identifier< ValueCoder : IValueCoder, Kind : IIdentifierKind > : IValueCoder where ValueCoder.SQLiteCoded : Hashable {
        
        public static func decode(_ value: KindSQLite.Value) throws -> KindCore.Identifier< ValueCoder.SQLiteCoded, Kind > {
            return .init(try ValueCoder.decode(value))
        }
        
        public static func encode(_ value: KindCore.Identifier< ValueCoder.SQLiteCoded, Kind >) throws -> KindSQLite.Value {
            return try ValueCoder.encode(value.id)
        }
        
    }
    
}

extension Identifier : IValueAlias where Raw : IValueAlias, Raw.SQLiteValueCoder.SQLiteCoded : Hashable {
    
    public typealias SQLiteValueCoder = ValueCoder.Identifier< Raw.SQLiteValueCoder, Kind >
    
}
