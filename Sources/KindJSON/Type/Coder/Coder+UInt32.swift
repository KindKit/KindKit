//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt32 : IValueCoder {
        
        public typealias JsonDecoded = Swift.UInt32
        public typealias JsonEncoded = Swift.UInt32
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uint32Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt32 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.UInt32
    public typealias JsonEncoder = Coder.UInt32
    
}
