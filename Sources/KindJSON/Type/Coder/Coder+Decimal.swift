//
//  KindKit
//

import Foundation

public extension Coder {

    struct Decimal : IValueCoder {
        
        public typealias JsonDecoded = Foundation.Decimal
        public typealias JsonEncoded = Foundation.Decimal
        typealias InternalCoder = Coder.NSDecimalNumber
        
        public static func decode(
            _ value: IValue,
            path: Path
        ) throws -> JsonDecoded {
            let decimal = try InternalCoder.decode(value, path: path)
            return decimal as Foundation.Decimal
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSDecimalNumber(decimal: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Decimal : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Decimal
    public typealias JsonEncoder = Coder.Decimal
    
}
