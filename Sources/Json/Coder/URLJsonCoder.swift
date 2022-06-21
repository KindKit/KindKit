//
//  KindKitJson
//

import Foundation

public struct URLJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> URL {
        let string = try StringJsonCoder.decode(value)
        guard let url = URL(string: string) else { throw JsonError.cast }
        return url
    }
    
    public static func encode(_ value: URL) throws -> IJsonValue {
        return value.absoluteString as NSString
    }
    
}

extension URL : IJsonCoderAlias {
    
    public typealias JsonDecoderType = URLJsonCoder
    public typealias JsonEncoderType = URLJsonCoder
    
}
