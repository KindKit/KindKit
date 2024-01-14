//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt16 : IValueCoder {
        
        public typealias JsonDecoded = Swift.UInt16
        public typealias JsonEncoded = Swift.UInt16
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uint16Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt16 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.UInt16
    public typealias JsonEncoder = Coder.UInt16
    
}
