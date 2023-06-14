//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Identifier< ValueCoder : IDatabaseValueCoder, Kind : IIdentifierKind > : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = KindKit.Identifier< ValueCoder.DatabaseCoded, Kind >
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            return .init(try ValueCoder.decode(value))
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            return try ValueCoder.encode(value.raw)
        }
        
    }
    
}

extension Identifier : IDatabaseValueAlias where Raw : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Identifier< Raw.DatabaseValueCoder, Kind >
    
}
