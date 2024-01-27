//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct NSStringCoder : ValueCoderTrait {
    
    public typealias JsonDecoded = NSString
    public typealias JsonDecodeOptions = EmptyCodingOptions
    
    public typealias JsonEncoded = NSString
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        if let value = field as? NSString {
            return value
        } else if let value = field as? NSDecimalNumber {
            return value.stringValue as NSString
        } else if let value = field as? NSNumber {
            return value.stringValue as NSString
        }
        throw CodingError(in: path)
    }
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return value
    }
    
}
