//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct Bool : IJsonValueCoder {
        
        public static func decode(_ value: IJsonValue) throws -> Swift.Bool {
            if let number = value as? Foundation.NSNumber {
                return number.boolValue
            } else if let string = value as? Foundation.NSString {
                switch string.lowercased {
                case "true", "yes", "on": return true
                case "false", "no", "off": return false
                default: break
                }
            }
            throw Json.Error.cast
        }
        
        public static func encode(_ value: Swift.Bool) throws -> IJsonValue {
            return Foundation.NSNumber(value: value)
        }
        
    }
    
}

extension Bool : IJsonCoderAlias {
    
    public typealias JsonDecoder = Json.Coder.Bool
    public typealias JsonEncoder = Json.Coder.Bool
    
}
