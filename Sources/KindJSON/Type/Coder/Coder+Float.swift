//
//  KindKit
//

import Foundation

public extension Coder {

    struct Float : IValueCoder {
        
        public typealias JsonDecoded = Swift.Float
        public typealias JsonEncoded = Swift.Float
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.floatValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Float : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Float
    public typealias JsonEncoder = Coder.Float
    
}
