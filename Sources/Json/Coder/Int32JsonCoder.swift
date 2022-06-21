//
//  KindKitJson
//

import Foundation

public struct Int32JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Int32 {
        return try NSNumberJsonCoder.decode(value).int32Value
    }
    
    public static func encode(_ value: Int32) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Int32 : IJsonCoderAlias {
    
    public typealias JsonDecoderType = Int32JsonCoder
    public typealias JsonEncoderType = Int32JsonCoder
    
}
