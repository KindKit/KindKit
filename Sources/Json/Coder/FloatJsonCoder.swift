//
//  KindKitJson
//

import Foundation

public struct FloatJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Float {
        return try NSNumberJsonCoder.decode(value).floatValue
    }
    
    public static func encode(_ value: Float) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Float : IJsonCoderAlias {
    
    public typealias JsonDecoderType = FloatJsonCoder
    public typealias JsonEncoderType = FloatJsonCoder
    
}
