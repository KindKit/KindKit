//
//  KindKitJson
//

import Foundation

public struct Int8JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Int8 {
        return try NSNumberJsonCoder.decode(value).int8Value
    }
    
    public static func encode(_ value: Int8) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Int8 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Int8JsonCoder
    public typealias JsonEncoder = Int8JsonCoder
    
}
