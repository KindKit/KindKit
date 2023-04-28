//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct URL : IJsonValueCoder {
        
        public typealias JsonDecoded = Foundation.URL
        public typealias JsonEncoded = Foundation.URL
        typealias InternalCoder = Json.Coder.String
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            guard let value = Foundation.URL(string: value) else {
                throw Json.Error.Coding.cast(path)
            }
            return value
        }
        
        public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
            return value.absoluteString as Foundation.NSString
        }
        
    }
    
}

extension URL : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.URL
    public typealias JsonEncoder = Json.Coder.URL
    
}
