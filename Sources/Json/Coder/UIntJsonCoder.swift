//
//  KindKitJson
//

import Foundation

public struct UIntJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> UInt {
        return try NSNumberJsonCoder.decode(value).uintValue
    }
    
    public static func encode(_ value: UInt) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt : IJsonCoderAlias {
    
    public typealias JsonDecoderType = UIntJsonCoder
    public typealias JsonEncoderType = UIntJsonCoder
    
}
