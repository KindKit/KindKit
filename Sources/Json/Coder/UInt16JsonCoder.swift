//
//  KindKitJson
//

import Foundation

public struct UInt16JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> UInt16 {
        return try NSNumberJsonCoder.decode(value).uint16Value
    }
    
    public static func encode(_ value: UInt16) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt16 : IJsonCoderAlias {
    
    public typealias JsonDecoderType = UInt16JsonCoder
    public typealias JsonEncoderType = UInt16JsonCoder
    
}
