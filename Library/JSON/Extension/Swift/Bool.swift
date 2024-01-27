//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Bool : ValueDecoderTrait {
    
    public typealias JsonDecoded = Bool
    public typealias JsonDecodeOptions = EmptyCodingOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        if let number = field as? NSNumber {
            return number.boolValue
        } else if let string = field as? NSString {
            switch string.lowercased {
            case "true", "yes", "on": return true
            case "false", "no", "off": return false
            default: break
            }
        }
        throw CodingError(in: path)
    }
    
}

extension Bool : ValueEncoderTrait {
    
    public typealias JsonEncoded = Bool
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return NSNumber(value: value)
    }
    
}
