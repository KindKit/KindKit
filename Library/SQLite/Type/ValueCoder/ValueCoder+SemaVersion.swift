//
//  KindKit
//

import KindCore

public extension ValueCoder {
    
    struct SemaVersion : IValueCoder {
        
        public static func decode(_ value: KindSQLite.Value) throws -> KindCore.SemaVersion {
            let string = try ValueCoder.Text.decode(value)
            guard let result = KindCore.SemaVersion(string) else {
                throw Error.decode
            }
            return result
        }
        
        public static func encode(_ value: KindCore.SemaVersion) throws -> KindSQLite.Value {
            return try ValueCoder.Text.encode(value.make())
        }
        
    }
    
}

extension SemaVersion : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.SemaVersion
    
}
