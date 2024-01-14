//
//  KindKit
//

import Foundation

public extension Coder {

    struct Double : IValueCoder {
        
        public typealias JsonDecoded = Swift.Double
        public typealias JsonEncoded = Swift.Double
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value.doubleValue
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Double : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Double
    public typealias JsonEncoder = Coder.Double
    
}
