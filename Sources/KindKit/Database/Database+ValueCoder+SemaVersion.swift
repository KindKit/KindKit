//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct SemaVersion : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = KindKit.SemaVersion
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            let string = try Database.ValueCoder.Text.decode(value)
            guard let result = KindKit.SemaVersion(string) else {
                throw Database.Error.decode
            }
            return result
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            return try Database.ValueCoder.Text.encode(value.make())
        }
        
    }
    
}

extension SemaVersion : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.SemaVersion
    
}
