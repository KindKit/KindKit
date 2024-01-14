//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int32 : IValueCoder {
        
        public typealias JsonDecoded = Swift.Int32
        public typealias JsonEncoded = Swift.Int32
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.int32Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int32 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Int32
    public typealias JsonEncoder = Coder.Int32
    
}
