//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int16 : IValueCoder {
        
        public typealias JsonDecoded = Swift.Int16
        public typealias JsonEncoded = Swift.Int16
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.int16Value
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int16 : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Int16
    public typealias JsonEncoder = Coder.Int16
    
}
