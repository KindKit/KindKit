//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {

    struct Bool : IUserDefaultsValueCoder {
        
        public static func decode(_ value: IUserDefaultsValue) throws -> Swift.Bool {
            if let number = value as? Foundation.NSNumber {
                return number.boolValue
            } else if let string = value as? Foundation.NSString {
                switch string.lowercased {
                case "true", "yes", "on": return true
                case "false", "no", "off": return false
                default: break
                }
            }
            throw UserDefaults.Error.cast
        }
        
        public static func encode(_ value: Swift.Bool) throws -> IUserDefaultsValue {
            return Foundation.NSNumber(value: value)
        }
        
    }
    
}

extension Bool : IUserDefaultsCoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Bool
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Bool
    
}
