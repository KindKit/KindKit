//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Date : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Foundation.Date {
            let number = try Json.Coder.NSNumber.decode(value)
            return Foundation.Date(timeIntervalSince1970: number.doubleValue)
        }
        
        public static func encode(_ value: Foundation.Date) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: Swift.Int(value.timeIntervalSince1970)))
        }
        
    }
    
}

extension Date : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Date
    public typealias JsonEncoder = Json.Coder.Date
    
}
