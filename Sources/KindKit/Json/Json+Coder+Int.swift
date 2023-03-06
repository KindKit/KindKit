//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Int : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Int {
            return try Json.Coder.NSNumber.decode(value).intValue
        }
        
        public static func encode(_ value: Swift.Int) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Int : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Int
    public typealias JsonEncoder = Json.Coder.Int
    
}
