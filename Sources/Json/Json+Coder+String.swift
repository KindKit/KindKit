//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct String : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.String {
            return try Json.Coder.NSString.decode(value) as Swift.String
        }
        
        public static func encode(_ value: Swift.String) throws -> IJsonValue {
            return try Json.Coder.NSString.encode(Foundation.NSString(string: value))
        }
        
    }
    
    struct NonEmptyString : IJsonValueDecoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.String {
            let string = try Json.Coder.String.decode(value)
            if string.isEmpty == true {
                throw Json.Error.cast
            }
            return string
        }
        
    }
    
}

extension String : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.String
    public typealias JsonEncoder = Json.Coder.String
    
}
