//
//  KindKitJson
//

import Foundation

public struct DoubleJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Double {
        return try NSNumberJsonCoder.decode(value).doubleValue
    }
    
    public static func encode(_ value: Double) throws -> IJsonValue {
        return try NSNumberJsonCoder.encode(NSNumber(value: value))
    }
    
}

extension Double : IJsonCoderAlias {
    
    public typealias JsonDecoder = DoubleJsonCoder
    public typealias JsonEncoder = DoubleJsonCoder
    
}
