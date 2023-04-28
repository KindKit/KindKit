//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct String : IJsonValueCoder {
        
        public typealias JsonDecoded = Swift.String
        public typealias JsonEncoded = Swift.String
        typealias InternalCoder = Json.Coder.NSString
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            return value as Swift.String
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            let value = Foundation.NSString(string: value)
            return try InternalCoder.encode(value, path: path)
        }
        
    }
    
    struct NonEmptyString : IJsonValueDecoder {
        
        public typealias JsonDecoded = Swift.String
        typealias InternalCoder = Json.Coder.String
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            if value.isEmpty == true {
                throw Json.Error.Coding.cast(path)
            }
            return value
        }
        
    }
    
}

extension String : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.String
    public typealias JsonEncoder = Json.Coder.String
    
}
