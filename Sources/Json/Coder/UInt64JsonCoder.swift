//
//  KindKitJson
//

import Foundation

public struct UInt64JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> UInt64 {
        return try NSNumberJsonCoder.decode(value).uint64Value
    }
    
    public static func encode(_ value: UInt64) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt64 : IJsonCoderAlias {
    
    public typealias JsonDecoderType = UInt64JsonCoder
    public typealias JsonEncoderType = UInt64JsonCoder
    
}
