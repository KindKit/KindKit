//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Optional< Wrapped : IDatabaseValueCoder > : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = Wrapped.DatabaseCoded?
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            switch value {
            case .null:
                return nil
            case .integer, .real, .text, .blob:
                return try Wrapped.decode(value)
            }
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            guard let value = value else {
                return .null
            }
            return try Wrapped.encode(value)
        }
        
    }
    
}

extension Optional : IDatabaseValueAlias where Wrapped : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Optional< Wrapped.DatabaseValueCoder >
    
}
