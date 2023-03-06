//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Double : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Double {
            return try Json.Coder.NSNumber.decode(value).doubleValue
        }
        
        public static func encode(_ value: Swift.Double) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Double : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Double
    public typealias JsonEncoder = Json.Coder.Double
    
}
