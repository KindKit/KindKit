//
//  KindKitJson
//

import Foundation

public struct BoolJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> Bool {
        if let number = value as? NSNumber {
            return number.boolValue
        } else if let string = value as? NSString {
            switch string.lowercased {
            case "true", "yes", "on": return true
            case "false", "no", "off": return false
            default: break
            }
        }
        throw JsonError.cast
    }
    
    public static func encode(_ value: Bool) throws -> IJsonValue {
        return NSNumber(value: value)
    }
    
}

extension Bool : IJsonCoderAlias {
    
    public typealias JsonDecoderType = BoolJsonCoder
    public typealias JsonEncoderType = BoolJsonCoder
    
}
