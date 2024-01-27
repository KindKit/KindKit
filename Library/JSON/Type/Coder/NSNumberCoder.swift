//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct NSNumberCoder : ValueCoderTrait {
    
    public typealias JsonDecoded = NSNumber
    public typealias JsonDecodeOptions = EmptyCodingOptions
    
    public typealias JsonEncoded = NSNumber
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        if let value = field as? NSNumber {
            return value
        } else if let value = field as? NSString {
            if let value = NSNumber.kk_number(from: value) {
                return value
            }
        }
        throw CodingError(in: path)
    }
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return value
    }
    
}
