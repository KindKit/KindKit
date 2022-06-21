//
//  KindKitJson
//

import Foundation

public struct IntJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Int {
        return try NSNumberJsonCoder.decode(value).intValue
    }
    
    public static func encode(_ value: Int) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Int : IJsonCoderAlias {
    
    public typealias JsonDecoderType = IntJsonCoder
    public typealias JsonEncoderType = IntJsonCoder
    
}
