//
//  KindKit
//

import Foundation

public extension Coder {

    struct Date : IValueCoder {
        
        public typealias JsonDecoded = Foundation.Date
        public typealias JsonEncoded = Foundation.Date
        typealias InternalCoder = Coder.NSNumber
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            let number = try InternalCoder.decode(value, path: path)
            return Foundation.Date(timeIntervalSince1970: number.doubleValue)
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            let value = Foundation.NSNumber(value: Swift.Int(value.timeIntervalSince1970))
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Date : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Date
    public typealias JsonEncoder = Coder.Date
    
}
