//
//  KindKit
//

import Foundation

public extension Coder {

    struct Int : IValueCoder {
        
        public typealias JsonDecoded = Swift.Int
        public typealias JsonEncoded = Swift.Int
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.intValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Int : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Int
    public typealias JsonEncoder = Coder.Int
    
}
