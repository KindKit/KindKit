//
//  KindKitJson
//

import Foundation

public struct NSNumberJsonCoder : IJsonValueCoder {
    
    public static func decode(_ value: IJsonValue) throws -> NSNumber {
        if let number = value as? NSNumber {
            return number
        } else if let string = value as? NSString, let number = NSNumber.number(from: string) {
            return number
        }
        throw JsonError.cast
    }
    
    public static func encode(_ value: NSNumber) throws -> IJsonValue {
        return value
    }
    
}
