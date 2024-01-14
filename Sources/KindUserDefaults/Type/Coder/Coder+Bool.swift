//
//  KindKit
//

import Foundation

public extension Coder {

    struct Bool : IValueCoder {
        
        public static func decode(_ value: IValue) throws -> Swift.Bool {
            if let number = value as? Foundation.NSNumber {
                return number.boolValue
            } else if let string = value as? Foundation.NSString {
                switch string.lowercased {
                case "true", "yes", "on": return true
                case "false", "no", "off": return false
                default: break
                }
            }
            throw Error.cast
        }
        
        public static func encode(_ value: Swift.Bool) throws -> IValue {
            return Foundation.NSNumber(value: value)
        }
        
    }
    
}

extension Bool : ICoderAlias {
    
    public typealias UserDefaultsDecoder = Coder.Bool
    public typealias UserDefaultsEncoder = Coder.Bool
    
}
