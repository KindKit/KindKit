//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct URL : IValueCoder {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Foundation.URL {
            let string = try ValueCoder.Text.decode(value)
            guard let result = Foundation.URL(string: string) else {
                throw Error.decode
            }
            return result
        }
        
        public static func encode(_ value: Foundation.URL) throws -> KindSQLite.Value {
            return try ValueCoder.Text.encode(value.absoluteString)
        }
        
    }
    
}

extension URL : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.URL
    
}
