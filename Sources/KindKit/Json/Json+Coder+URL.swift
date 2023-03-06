//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct URL : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Foundation.URL {
            let string = try Json.Coder.String.decode(value)
            guard let url = Foundation.URL(string: string) else {
                throw Json.Error.cast
            }
            return url
        }
        
        public static func encode(_ value: Foundation.URL) throws -> IJsonValue {
            return value.absoluteString as Foundation.NSString
        }
        
    }
    
}

extension URL : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.URL
    public typealias JsonEncoder = Json.Coder.URL
    
}
