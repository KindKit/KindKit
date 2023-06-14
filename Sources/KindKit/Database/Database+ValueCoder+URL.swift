//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct URL : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = Foundation.URL
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            let string = try Database.ValueCoder.Text.decode(value)
            guard let result = Foundation.URL(string: string) else {
                throw Database.Error.decode
            }
            return result
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            return try Database.ValueCoder.Text.encode(value.absoluteString)
        }
        
    }
    
}

extension URL : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.URL
    
}
