//
//  KindKit
//

import Foundation

public extension Coder {

    struct UInt : IValueCoder {
        
        public typealias JsonDecoded = Swift.UInt
        public typealias JsonEncoded = Swift.UInt
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.uintValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension UInt : ICoderAlias {
    
    public typealias JsonDecoder = Coder.UInt
    public typealias JsonEncoder = Coder.UInt
    
}
