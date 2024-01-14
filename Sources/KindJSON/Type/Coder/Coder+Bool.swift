//
//  KindKit
//

import Foundation

public extension Coder {

    struct Bool : IValueCoder {
        
        public typealias JsonDecoded = Swift.Bool
        public typealias JsonEncoded = Swift.Bool
        
        public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
            if let number = value as? Foundation.NSNumber {
                return number.boolValue
            } else if let string = value as? Foundation.NSString {
                switch string.lowercased {
                case "true", "yes", "on": return true
                case "false", "no", "off": return false
                default: break
                }
            }
            throw Error.Coding.cast(path)
        }
        
        public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
            return Foundation.NSNumber(value: value)
        }
        
    }
    
}

extension Bool : ICoderAlias {
    
    public typealias JsonDecoder = Coder.Bool
    public typealias JsonEncoder = Coder.Bool
    
}
