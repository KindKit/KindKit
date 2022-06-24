//
//  KindKitJson
//

import Foundation

public struct UInt32JsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> UInt32 {
        return try NSNumberJsonCoder.decode(value).uint32Value
    }
    
    public static func encode(_ value: UInt32) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension UInt32 : IJsonCoderAlias {
    
    public typealias JsonDecoder = UInt32JsonCoder
    public typealias JsonEncoder = UInt32JsonCoder
    
}
