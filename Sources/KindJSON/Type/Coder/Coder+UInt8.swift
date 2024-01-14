//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt8 : IValueCoder {
        
        public typealias JsonDecoded = Swift.UInt8
        public typealias JsonEncoded = Swift.UInt8
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uint8Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt8 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.UInt8
    public typealias JsonEncoder = Coder.UInt8
    
}
