//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Date : IJsonValueCoder {
        
        public typealias JsonDecoded = Foundation.Date
        public typealias JsonEncoded = Foundation.Date
        typealias InternalCoder = Json.Coder.NSNumber
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let number = try InternalCoder.decode(value, path: path)
            return Foundation.Date(timeIntervalSince1970: number.doubleValue)
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSNumber(value: Swift.Int(value.timeIntervalSince1970))
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
}

extension Date : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Date
    public typealias JsonEncoder = Json.Coder.Date
    
}
