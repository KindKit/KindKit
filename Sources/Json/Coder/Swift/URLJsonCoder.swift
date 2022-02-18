//
//  KindKitJson
//

import Foundation

public struct URLJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> URL {
        let string = try NSStringJsonCoder.decode(value)
        if let url = URL(string: string as String) {
            return url
        }
        throw JsonError.cast
    }
    
    public static func encode(_ value: URL) throws -> IJsonValue {
        return value.absoluteString as NSString
    }
    
}

extension URL : IJsonCoderAlias {
    
    public typealias JsonDecoder = URLJsonCoder
    public typealias JsonEncoder = URLJsonCoder
    
}
