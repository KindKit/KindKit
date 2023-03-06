//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Float : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Float {
            return try Json.Coder.NSNumber.decode(value).floatValue
        }
        
        public static func encode(_ value: Swift.Float) throws -> IJsonValue {
            return try Json.Coder.NSNumber.encode(Foundation.NSNumber(value: value))
        }
        
    }
    
}

extension Float : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Float
    public typealias JsonEncoder = Json.Coder.Float
    
}
