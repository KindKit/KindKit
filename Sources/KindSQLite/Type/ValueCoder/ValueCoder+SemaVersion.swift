//
//  KindKit
//

import KindCore

public extension ValueCoder {
    
    struct SemaVersion : IValueCoder {
        
        public typealias SQLiteCoded = KindCore.SemaVersion
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
            let string = try ValueCoder.Text.decode(value)
            guard let result = KindCore.SemaVersion(string) else {
                throw Error.decode
            }
            return result
        }
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return try ValueCoder.Text.encode(value.make())
        }
        
    }
    
}

extension SemaVersion : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.SemaVersion
    
}
