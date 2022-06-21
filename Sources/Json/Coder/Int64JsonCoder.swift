//
//  KindKitJson
//

import Foundation

public struct Int64JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Int64 {
        return try NSNumberJsonCoder.decode(value).int64Value
    }
    
    public static func encode(_ value: Int64) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Int64 : IJsonCoderAlias {
    
    public typealias JsonDecoderType = Int64JsonCoder
    public typealias JsonEncoderType = Int64JsonCoder
    
}
