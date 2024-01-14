//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int8 : IValueCoder {
        
        public typealias JsonDecoded = Swift.Int8
        public typealias JsonEncoded = Swift.Int8
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.int8Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int8 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Int8
    public typealias JsonEncoder = Coder.Int8
    
}
