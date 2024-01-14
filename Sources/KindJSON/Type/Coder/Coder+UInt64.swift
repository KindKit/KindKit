//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt64 : IValueCoder {
        
        public typealias JsonDecoded = Swift.UInt64
        public typealias JsonEncoded = Swift.UInt64
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uint64Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt64 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.UInt64
    public typealias JsonEncoder = Coder.UInt64
    
}
