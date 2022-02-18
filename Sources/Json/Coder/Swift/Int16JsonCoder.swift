//
//  KindKitJson
//

import Foundation

public struct Int16JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Int16 {
        return try NSNumberJsonCoder.decode(value).int16Value
    }
    
    public static func encode(_ value: Int16) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Int16 : IJsonCoderAlias {
    
    public typealias JsonDecoder = Int16JsonCoder
    public typealias JsonEncoder = Int16JsonCoder
    
}
