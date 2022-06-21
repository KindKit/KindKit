//
//  KindKitJson
//

import Foundation

public struct StringJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> String {
        return try NSStringJsonCoder.decode(value) as String
    }
    
    public static func encode(_ value: String) throws -> IJsonValue {
        return try NSStringJsonCoder.encode(NSString(string: value))
    }
    
}

public struct NonEmptyStringJsonDecoder : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> String {
        let string = try StringJsonCoder.decode(value)
        if string.isEmpty == true {
            throw JsonError.cast
        }
        return string
    }
    
}

extension String : IJsonCoderAlias {
    
    public typealias JsonDecoderType = StringJsonCoder
    public typealias JsonEncoderType = StringJsonCoder
    
}
