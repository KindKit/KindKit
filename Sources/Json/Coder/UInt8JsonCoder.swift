//
//  KindKitJson
//

import Foundation

public struct UInt8JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> UInt8 {
        return try NSNumberJsonCoder.decode(value).uint8Value
    }
    
    public static func encode(_ value: UInt8) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt8 : IJsonCoderAlias {
    
    public typealias JsonDecoderType = UInt8JsonCoder
    public typealias JsonEncoderType = UInt8JsonCoder
    
}
