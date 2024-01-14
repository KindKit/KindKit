//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct URL : IValueCoder {
        
        public typealias SQLiteCoded = Foundation.URL
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            let string = try ValueCoder.Text.decode(value)
            guard let result = Foundation.URL(string: string) else {
                throw Error.decode
            }
            return result
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return try ValueCoder.Text.encode(value.absoluteString)
        }
        
    }
    
}

extension URL : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.URL
    
}
