//
//  KindKitJson
//

import Foundation

public struct DateJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Date {
        let number = try NSNumberJsonCoder.decode(value)
        return Date(timeIntervalSince1970: number.doubleValue)
    }
    
    public static func encode(_ value: Date) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: Int(value.timeIntervalSince1970)))
    }
    
}

extension Date : IJsonCoderAlias {
    
    public typealias JsonDecoderType = DateJsonCoder
    public typealias JsonEncoderType = DateJsonCoder
    
}
