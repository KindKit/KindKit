//
//  KindKit
//

import Foundation
import KindCodingOptions

public struct NSDecimalNumberCoder : ValueCoderTrait {
    
    public typealias JsonDecoded = NSDecimalNumber
    public typealias JsonDecodeOptions = EmptyCodingOptions
    
    public typealias JsonEncoded = NSDecimalNumber
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        if let decimalNumber = field as? NSDecimalNumber {
            return decimalNumber
        } else if let number = field as? NSNumber {
            return .init(string: number.stringValue)
        } else if let string = field as? NSString {
            if let decimalNumber = NSDecimalNumber.kk_decimalNumber(from: string) {
                return decimalNumber
            }
        }
        throw CodingError(in: path)
    }
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return value
    }
    
}
