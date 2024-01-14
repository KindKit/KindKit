//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int64 : IValueCoder {
        
        public typealias JsonDecoded = Swift.Int64
        public typealias JsonEncoded = Swift.Int64
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.int64Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int64 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Int64
    public typealias JsonEncoder = Coder.Int64
    
}
